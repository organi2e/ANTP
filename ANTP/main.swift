//
//  main.swift
//  ANTP
//
//  Created by Kota Nakano on 1/9/18.
//  Copyright © 2018 organi2e. All rights reserved.
//
import MultipeerConnectivity
import os.log
class Peer: NSObject {
	let facility: OSLog
	let session: MCSession
	let advertiser: MCNearbyServiceAdvertiser
	let browser: MCNearbyServiceBrowser
	let timer: DispatchSourceTimer
	let trust: TrustCheck
	var cputime: Decimal {
		var ts: timespec = timespec()
		guard clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &ts) == 0 else {
			os_log("%{public}@, %d", log: facility, type: .error, #file, #line)
			return .nan
		}
		var decimal: Decimal = 0
		NSDecimalMultiplyByPowerOf10(&decimal, [Decimal(ts.tv_nsec)], -9, .plain)
		return Decimal(ts.tv_sec) + decimal
	}
	var rtctime: Decimal {
		var ts: timespec = timespec()
		guard clock_gettime(CLOCK_REALTIME, &ts) == 0 else {
			os_log("%{public}@, %d", log: facility, type: .error, #file, #line)
			return .nan
		}
		var decimal: Decimal = 0
		NSDecimalMultiplyByPowerOf10(&decimal, [Decimal(ts.tv_nsec)], -9, .plain)
		return Decimal(ts.tv_sec) + decimal
	}
	private func handler() {
		let sorted: [MCPeerID] = session.connectedPeers.sorted {
			$0.displayName < $1.displayName
		}
		guard let dwarf: MCPeerID = sorted.first, dwarf.displayName < session.myPeerID.displayName else {
			os_log("no peer found", log: facility, type: .info)
			return
		}
		let archiver: NSKeyedArchiver = NSKeyedArchiver()
		archiver.encodeRootObject(cputime)
		do {
			try session.send(archiver.encodedData, toPeers: [dwarf], with: .unreliable)
		} catch {
			os_log("%{public}@", log: facility, type: .error, error.localizedDescription)
		}
	}
	override init() {
		let myPeerID: MCPeerID = MCPeerID(displayName: [Host.current().name ?? ".local", UUID().uuidString].joined(separator: "-"))
		let procName: String = ProcessInfo.processInfo.processName
		facility = OSLog(subsystem: procName, category: String(describing: type(of: self)))
		session = MCSession(peer: myPeerID)
		advertiser = MCNearbyServiceAdvertiser(peer: myPeerID, discoveryInfo: nil, serviceType: procName)
		browser = MCNearbyServiceBrowser(peer: myPeerID, serviceType: procName)
		timer = DispatchSource.makeTimerSource()
		trust = TrustMV(ratio: 0.95, limit: 0.95)
		super.init()
		session.delegate = self
		advertiser.delegate = self
		advertiser.startAdvertisingPeer()
		browser.delegate = self
		browser.startBrowsingForPeers()
		timer.schedule(deadline: .now(), repeating: 1)
		timer.setEventHandler(handler: handler)
		timer.resume()
	}
}
let p: Process = Process()
p.launchPath = "/usr/sbin/systemsetup"
p.arguments = ["setusingnetworktime", "off"]
p.launch()
p.waitUntilExit()
if p.terminationStatus == 0 {
	withExtendedLifetime(Peer(), RunLoop.current.run)
}
