//
//  setdate.swift
//  ANTP
//
//  Created by Kota Nakano on 1/9/18.
//  Copyright © 2018 organi2e. All rights reserved.
//
import Foundation
import os.log
extension Decimal {
	func idsplit(order: Int16) -> (Int, Int) {
		var integer: Decimal = 0
		var decimal: Decimal = 0
		NSDecimalRound(&integer, [self], 0, .plain)
		NSDecimalMultiplyByPowerOf10(&decimal, [self - integer], order, .plain)
		return((integer as NSDecimalNumber).intValue,
			   (decimal as NSDecimalNumber).intValue)
	}
}
extension Peer {
	func adjust(delta: Decimal) {
		os_log("delay %{public}@", log: facility, type: .info, delta.description)
		if 0.5 < abs(delta) {
			let(sec, nsec): (Int, Int) = delta.idsplit(order: 9)
			var ts: timespec = timespec()
			guard clock_gettime(CLOCK_REALTIME, &ts) == 0 else {
				os_log("adjust step get failed, errno: %d", log: facility, type: .error, errno)
				return
			}
			ts.tv_sec += sec
			ts.tv_nsec += nsec
			guard clock_settime(CLOCK_REALTIME, &ts) == 0 else {
				os_log("adjust step set failed, errno: %d", log: facility, type: .error, errno)
				return
			}
		} else {
			let(sec, usec): (Int, Int) = delta.idsplit(order: 6)
			var tv: timeval = timeval(tv_sec: sec, tv_usec: __darwin_suseconds_t(usec))
			guard adjtime(&tv, nil) == 0 else {
				os_log("adjust slew failed, errno: %d", log: facility, type: .error, errno)
				return
			}
		}
	}
}
