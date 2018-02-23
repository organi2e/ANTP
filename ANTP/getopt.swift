//
//  getopt.swift
//  ANTP
//
//  Created by Kota Nakano on 2/23/18.
//  Copyright © 2018 organi2e. All rights reserved.
//
import Foundation
func getopt(default: [String: [Any]]) -> ([String: (Bool, [Any])], [String]) {
	var mutable: [String: (Bool, [Any])] = `default`.mapValues { (false, $0) }
	let (rest, _, _): ([String], String, Int) = ProcessInfo.processInfo.arguments.dropFirst().reduce(([String](), "", 0)) {
		if $0.1.isEmpty {
			mutable[$1]?.0 = true
			return mutable.keys.contains($1) ? ($0.0, $1, 0) : ($0.0 + [$1], "", 0)
		} else if let v: [Any] = mutable[$0.1]?.1, $0.2 < v.count {
			mutable[$0.1]?.1[$0.2] = {
				switch $0 {
				case let val as Int: return Int($1) ?? val
				case let val as Int8: return Int8($1) ?? val
				case let val as Int16: return Int16($1) ?? val
				case let val as Int32: return Int32($1) ?? val
				case let val as Int64: return Int64($1) ?? val
					
				case let val as UInt: return UInt($1) ?? val
				case let val as UInt8: return UInt8($1) ?? val
				case let val as UInt16: return UInt16($1) ?? val
				case let val as UInt32: return UInt32($1) ?? val
				case let val as UInt64: return UInt64($1) ?? val
					
				case let val as Float: return Float($1) ?? val
				case let val as Double: return Double($1) ?? val
				case let val as Decimal: return Decimal(string: $1) ?? val
					
				case let val as Bool: return Bool($1) ?? val
					
				default: return $1
				}
			} (v[$0.2], $1)
			return $0.2 < v.count - 1 ? ([], $0.1, $0.2 + 1) : ([], "", 0)
		} else {
			return ($0.0 + [$1], "", 0)
		}
	}
	return (mutable, rest)
}
