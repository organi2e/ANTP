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
	func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
		let unarchiver: NSKeyedUnarchiver = NSKeyedUnarchiver(forReadingWith: data)
		do {
			guard let request: Decimal = unarchiver.decodeObject()as?Decimal else {
				throw NSError(domain: #file, code: #line, userInfo: nil)
			}
			if let ref: Decimal = unarchiver.decodeObject(forKey: "rtc")as?Decimal {
				let duration: Decimal = cputime - request
				let delay: Decimal = ref - rtctime
				guard trust.isTrust(duration: duration) else {
					let message: String = "unreliable: \(duration)"
					os_log("%{public}@", log: facility, type: .info, message)
					return
				}
				adjust(delta: delay + duration / 2)
			} else {
				let archiver: NSKeyedArchiver = NSKeyedArchiver()
				archiver.encodeRootObject(request)
				archiver.encode(rtctime, forKey: "rtc")
				try session.send(archiver.encodedData, toPeers: [peerID], with: .unreliable)
			}
		} catch {
			os_log("%{public}@", log: facility, type: .error, error.localizedDescription)
		}
	}
}
extension Peer {
	func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
		certificateHandler(true)
	}
}
extension Peer {
	func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
		switch state {
		case .connected:
			break
		case .notConnected:
			break
		case .connecting:
			break
		}
	}
}
extension Peer {
	func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
		let message: String = "\(#function) has not been implemented"
		os_log("%{public}@", log: facility, type: .info, message)
		assertionFailure(message)
	}
	func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
		let message: String = "\(#function) has not been implemented"
		os_log("%{public}@", log: facility, type: .info, message)
		assertionFailure(message)
	}
	func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
		let message: String = "\(#function) has not been implemented"
		os_log("%{public}@", log: facility, type: .info, message)
		assertionFailure(message)
	}
}
extension Peer: MCSessionDelegate {}
