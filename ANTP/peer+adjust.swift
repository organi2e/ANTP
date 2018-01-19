//
//  setdate.swift
//  ANTP
//
//  Created by Kota Nakano on 1/9/18.
//  Copyright © 2018 organi2e. All rights reserved.
//
import MultipeerConnectivity
import os.log
extension Peer {
	private func getCPU() throws -> Decimal {
		var ts: timespec = timespec()
		guard clock_gettime(CLOCK_PROCESS_CPUTIME_ID, &ts) == 0 else {
			throw NSError(domain: #file, code: #line, userInfo: ["errno": errno])
		}
		return ts.decimal
	}
	private func getRTC() throws -> Decimal {
		var ts: timespec = timespec()
		guard clock_gettime(CLOCK_REALTIME, &ts) == 0 else {
			throw NSError(domain: #file, code: #line, userInfo: ["errno": errno])
		}
		return ts.decimal
	}
	private func adjust(Δ: Decimal) throws {
		if 0.5 < abs(Δ) {
			var origin: timespec = timespec()
			guard clock_gettime(CLOCK_REALTIME, &origin) == 0 else {
				throw NSError(domain: #file, code: #line, userInfo: ["errno": errno])
			}
			var target: timespec = (origin.decimal + Δ).ts
			guard clock_settime(CLOCK_REALTIME, &target) == 0 else {
				throw NSError(domain: #file, code: #line, userInfo: ["errno": errno])
			}
			os_log("step adjust delay %{public}@", log: facility, type: .info, Δ.description)
		} else {
			var tv: timeval = Δ.tv
			guard adjtime(&tv, nil) == 0 else {
				throw NSError(domain: #file, code: #line, userInfo: ["errno": errno])
			}
			os_log("slew adjust delay %{public}@", log: facility, type: .info, Δ.description)
		}
	}
	func request() {
		guard !session.connectedPeers.isEmpty else {
			os_log("no connected peer found", log: facility, type: .info)
			return
		}
		let sorted: [MCPeerID] = session.connectedPeers.sorted {
			$0.displayName < $1.displayName
		}
		guard let dwarf: MCPeerID = sorted.first, dwarf.displayName < session.myPeerID.displayName else {
			os_log("any peer shouldn't be refer", log: facility, type: .info)
			return
		}
		do {
			let archiver: NSKeyedArchiver = NSKeyedArchiver()
			try archiver.encodeRootObject(getCPU())
			try session.send(archiver.encodedData, toPeers: [dwarf], with: .unreliable)
		} catch {
			os_log("%{public}@", log: facility, type: .error, String(describing: error))
		}
	}
	func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
		let unarchiver: NSKeyedUnarchiver = NSKeyedUnarchiver(forReadingWith: data)
		do {
			guard let request: Decimal = unarchiver.decodeObject()as?Decimal else {
				throw NSError(domain: #file, code: #line, userInfo: nil)
			}
			if let ref: Decimal = unarchiver.decodeObject(forKey: "rtc")as?Decimal {
				let duration: Decimal = try getCPU() - request
				let delay: Decimal = try ref - getRTC()
				guard trust.isTrust(duration: duration) else {
					throw NSError(domain: #file, code: #line, userInfo: ["duration": duration])
				}
				try adjust(Δ: delay + duration / 2)
			} else {
				let archiver: NSKeyedArchiver = NSKeyedArchiver()
				archiver.encodeRootObject(request)
				try archiver.encode(getRTC(), forKey: "rtc")
				try session.send(archiver.encodedData, toPeers: [peerID], with: .unreliable)
			}
		} catch {
			os_log("%{public}@", log: facility, type: .error, String(describing: error))
		}
	}
}
