//
//  session.swift
//  ANTP
//
//  Created by Kota Nakano on 1/9/18.
//  Copyright © 2018 organi2e. All rights reserved.
//
import MultipeerConnectivity
import os.log
extension Peer {
	func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
		certificateHandler(true)
	}
}
extension Peer {
	func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
		
	}
}
extension Peer {
	func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
		let message: String = "\(#function) has not been implemented"
		os_log("%{public}@", log: facility, type: .fault, message)
		assertionFailure(message)
	}
	func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
		let message: String = "\(#function) has not been implemented"
		os_log("%{public}@", log: facility, type: .fault, message)
		assertionFailure(message)
	}
	func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
		let message: String = "\(#function) has not been implemented"
		os_log("%{public}@", log: facility, type: .fault, message)
		assertionFailure(message)
	}
}
extension Peer: MCSessionDelegate {}
