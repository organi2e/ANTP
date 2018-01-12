//
//  advertiser.swift
//  ANTP
//
//  Created by Kota Nakano on 1/9/18.
//  Copyright © 2018 organi2e. All rights reserved.
//
import MultipeerConnectivity
import os.log
extension Peer {
	func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
		invitationHandler(true, session)
	}
}
extension Peer {
	func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
		os_log("%{public}@", log: facility, type: .fault, error.localizedDescription)
		assertionFailure(error.localizedDescription)
	}
}
extension Peer: MCNearbyServiceAdvertiserDelegate {}
