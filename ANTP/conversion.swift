//
//  conversion.swift
//  ANTP
//
//  Created by Kota Nakano on 1/12/18.
//  Copyright © 2018 organi2e. All rights reserved.
//
import Foundation
extension Decimal {
	private var intValue: Int {
		return (self as NSDecimalNumber).intValue
	}
	private var int32Value: Int32 {
		return (self as NSDecimalNumber).int32Value
	}
	var ts: timespec {
		var integer: Decimal = .nan
		var decimal: Decimal = .nan
		NSDecimalRound(&integer, [magnitude], 0, .down)
		NSDecimalMultiplyByPowerOf10(&decimal, [magnitude-integer], 9, .down)
		switch sign {
		case .plus:
			return timespec(tv_sec: integer.intValue, tv_nsec: decimal.intValue)
		case .minus:
			return timespec(tv_sec: -integer.intValue, tv_nsec: -decimal.intValue)
		}
	}
	var tv: timeval {
		var integer: Decimal = .nan
		var decimal: Decimal = .nan
		NSDecimalRound(&integer, [magnitude], 0, .down)
		NSDecimalMultiplyByPowerOf10(&decimal, [magnitude-integer], 6, .down)
		switch sign {
		case .plus:
			return timeval(tv_sec: integer.intValue, tv_usec: decimal.int32Value)
		case .minus:
			return timeval(tv_sec: -integer.intValue, tv_usec: -decimal.int32Value)
		}
//		return timeval(tv_sec: integer.intValue, tv_usec: decimal.int32Value)
	}
}
extension timeval {
	var decimal: Decimal {
		var integer: Decimal = Decimal(tv_usec)
		var decimal: Decimal = .nan
		NSDecimalMultiplyByPowerOf10(&decimal, &integer, -6, .plain)
		return Decimal(tv_sec) + decimal
	}
}
extension timespec {
	var decimal: Decimal {
		var integer: Decimal = Decimal(tv_nsec)
		var decimal: Decimal = .nan
		NSDecimalMultiplyByPowerOf10(&decimal, &integer, -9, .plain)
		return Decimal(tv_sec) + decimal
	}
}
