//
//  main.swift
//  ANTP
//
//  Created by Kota Nakano on 1/9/18.
//  Copyright © 2018 organi2e. All rights reserved.
//
import Foundation
let p: Process = Process()
p.launchPath = "/usr/sbin/systemsetup"
p.arguments = ["setusingnetworktime", "off"]
p.launch()
p.waitUntilExit()
if p.terminationStatus == 0 {
	withExtendedLifetime(Peer(), RunLoop.current.run)
}
