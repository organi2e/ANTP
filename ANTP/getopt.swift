//
//  getopt.swift
//  ANTP
//
//  Created by Kota Nakano on 2/23/18.
//  Copyright © 2018 organi2e. All rights reserved.
//
import Foundation
func getopt(default: [String: [Any]]) -> ([String: (Bool, [Any])], [String]) {
	let (opt, rest, _, _): ([String: (Bool, [Any])], [String], String, Int) = ProcessInfo.processInfo.arguments.dropFirst().reduce((`default`.mapValues {(false, $0)}, [String](), "", 0)) {
		let key: String = $0.2
		let idx: Int = $0.3
		if key.isEmpty {
			return $0.0.keys.contains($1) ? ($0.0.merging([$1: (true, [])]) { ($1.0, $0.1) }, $0.1, $1, 0) : ($0.0, $0.1 + [$1], "", 0)
		} else if let v: (Bool, [Any]) = $0.0[key], idx < v.1.count {
			let val: Any = {
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
			} (v.1[idx], $1)
			let sum: [String: (Bool, [Any])] = $0.0.merging([key: (true, [])]) {
				($1.0, $0.1.enumerated().map { [$0.offset == idx ? val : $0.element] }.reduce([], +))
			}
			return idx < v.1.count - 1 ? (sum, [], key, idx + 1) : (sum, [], "", 0)
		} else {
			return ($0.0, $0.1 + [$1], "", 0)
		}
	}
	return (opt, rest)
}
