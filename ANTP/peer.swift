//
//  peer.swift
//  ANTP
//
//  Created by Kota Nakano on 1/12/18.
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
	override init() {
		let myPeerID: MCPeerID = MCPeerID(displayName: Host.current().name ?? ".local")
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
		timer.setEventHandler(handler: request)
		timer.resume()
	}
}

