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
    func send(_ name : String,_ message: [Any]) {
            guard WCSession.default.activationState == .activated else {
              return
            }
            #if os(iOS)
            guard WCSession.default.isWatchAppInstalled else {
                return
            }
            #else
            guard WCSession.default.isCompanionAppInstalled else {
                return
            }
            #endif
            
            WCSession.default.sendMessage([name : message], replyHandler: nil) { error in
                print("Cannot send message: \(String(describing: error))")
            }
        }
    //aw
}

extension WC: WCSessionDelegate {
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
            if let notificationText = message["Tasks"] as? ToDo {
                DispatchQueue.main.async { [weak self] in
                    try! ToDo(context: PersistenceController.shared.container.viewContext , name: notificationText.name ?? "error")
                }
            }
        }
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
