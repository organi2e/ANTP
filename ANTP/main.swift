//
//  main.swift
//  ANTP
//
//  Created by Kota Nakano on 1/9/18.
//  Copyright © 2018 organi2e. All rights reserved.
//
import Foundation
let defaultτ: Decimal = 1
let defaultt: Double = 6
let opt: [String: (Bool, [Any])] = getopt(default: ["--threshold": [defaultτ], "--interval": [defaultt]]).0
let τ: Decimal = opt["--threshold"]?.1.first as? Decimal ?? defaultτ
let t: Double = opt["--interval"]?.1.first as? Double ?? defaultt
let p: Process = Process()
p.launchPath = "/usr/sbin/systemsetup"
p.arguments = ["setusingnetworktime", "off"]
p.launch()
p.waitUntilExit()
if p.terminationStatus == 0 {
	withExtendedLifetime(Peer(), RunLoop.current.run)
}
