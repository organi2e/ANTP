//
//  browser.swift
//  ANTP
//
//  Created by Kota Nakano on 1/9/18.
//  Copyright © 2018 organi2e. All rights reserved.
//
import MultipeerConnectivity
import os.log
extension Peer {
	func browser(_ browser: MCNearbyServiceBrowser, foundPeer peerID: MCPeerID, withDiscoveryInfo info: [String : String]?) {
		browser.invitePeer(peerID, to: session, withContext: nil, timeout: 9)
	}
}
extension Peer {
	func browser(_ browser: MCNearbyServiceBrowser, lostPeer peerID: MCPeerID) {
		
	}
}
extension Peer {
	func browser(_ browser: MCNearbyServiceBrowser, didNotStartBrowsingForPeers error: Error) {
		os_log("%{public}@", log: facility, type: .fault, error.localizedDescription)
		assertionFailure(error.localizedDescription)
	}
}
extension Peer: MCNearbyServiceBrowserDelegate {}
