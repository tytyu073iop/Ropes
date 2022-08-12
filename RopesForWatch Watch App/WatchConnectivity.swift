//
//  WatchConnectivity.swift
//  RopesForWatch Watch App
//
//  Created by Илья Бирюк on 12.08.22.
//

import Foundation
import SwiftUI
import WatchConnectivity

final class WC : NSObject {
    static let shared = WC()
    //aw
    private override init() {
        super.init()
        
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    //aw
}

extension WC: WCSessionDelegate {
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {}
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        //session.activate() //From guide
        WCSession.default.activate()
    }
    #endif
}
