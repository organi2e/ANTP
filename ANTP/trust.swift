//
//  trust.swift
//  ANTP
//
//  Created by Kota Nakano on 1/10/18.
//  Copyright © 2018 organi2e. All rights reserved.
//
import Foundation
import os.log
//信頼できる遅延か応答時刻から逐次的に判断
protocol TrustCheck {
	func isTrust(duration: Decimal) -> Bool
}
//応答時間が正規分布と仮定し平均に近い場合に信頼
class TrustMV: TrustCheck {
	var m1: Decimal
	var m2: Decimal
	let mix:(Decimal, Decimal)
	let threshold: Double
	init(ratio: Decimal, limit: Double) {
		m1 = 0
		m2 = 0
		mix = (ratio, 1 - ratio)
		threshold = limit
	}
	func isTrust(duration: Decimal) -> Bool {
		m1 = mix.0 * m1 + mix.1 * ( duration )
		m2 = mix.0 * m2 + mix.1 * ( duration * duration )
		let m: Decimal = m1
		let v: Decimal = m2 - m1 * m1
		let d: Decimal = duration - m
		let x: NSDecimalNumber = d * d / v / -2 as NSDecimalNumber
		let s: NSDecimalNumber = 2 * v * .pi as NSDecimalNumber
		return threshold < exp(x.doubleValue) / sqrt(s.doubleValue)
	}
}
//応答時間の最小値を保持し最小値に近い場合に信頼
class TrustMn: TrustCheck {
	var minduration: Decimal
	let threshold: Decimal
	init(limit: Decimal) {
		minduration = .greatestFiniteMagnitude
		threshold = limit
	}
	func isTrust(duration: Decimal) -> Bool {
		minduration = min(duration, minduration)
		return duration / minduration < threshold
	}
}
//応答時間の最頻値を逐次近似し中央値に近い場合に信頼
class TrustMd: TrustCheck {
	var queue: [Decimal]
	let length: Int
	let range: (Double, Double)
	init(ratio: Double, limit: Int) {
		length = limit
		range = (0.5*(1-ratio), 0.5*(1+ratio))
		queue = []
	}
	func isTrust(duration: Decimal) -> Bool {
		queue.append(duration)
		queue.sort()
		remove: while length < queue.count {
			if queue.count % 2 == 0, 2 < queue.count {
				_ = (queue.removeFirst(), queue.removeLast())
			} else {
				break remove
			}
		}
		guard let index: Int = queue.index(of: duration) else {
			return false
		}
		let position: Double = Double(index) / Double(queue.count)
		guard range.0 < position, position < range.1 else {
			return false
		}
		return true
	}
}
