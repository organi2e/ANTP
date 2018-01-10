//
//  trust.swift
//  ANTP
//
//  Created by Kota Nakano on 1/10/18.
//  Copyright © 2018 organi2e. All rights reserved.
//
import Foundation
import os.log
protocol TrustCheck {
	func isTrust(duration: Decimal) -> Bool
}
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
		let d: Decimal = ( duration - m )
		let x: NSDecimalNumber = d * d / v / -2 as NSDecimalNumber
		let s: NSDecimalNumber = 2 * v * .pi as NSDecimalNumber
		return threshold < exp(x.doubleValue) / sqrt(s.doubleValue)
	}
}
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
class TrustMd: TrustCheck {
	var queue: [Decimal]
	var coins: Bool = true
	let length: Int
	let range: (Double, Double)
	init(ratio: Double, limit: Int) {
		length = limit
		range = (0.5*(1-ratio), 0.5*(1+ratio))
		coins = true
		queue = []
	}
	func isTrust(duration: Decimal) -> Bool {
		queue.append(duration)
		queue.sort()
		if length < queue.count {
			if coins {
				_ = queue.removeFirst()
			} else {
				_ = queue.removeLast()
			}
			coins = !coins
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
