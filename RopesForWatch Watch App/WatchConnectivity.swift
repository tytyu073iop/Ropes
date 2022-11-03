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
            print("session activated")
        }
    }
    @MainActor private func Sync(_ userInfo: [String : Any]) {
        if let fastAnswers = userInfo["FastAnswers"] as? [[String : Any]] {
            print("FA")
            for fastAnswer in fastAnswers {
                if let name = fastAnswer["Name"] as? String {
                    do {
                        try FastAnswers(id: UUID(uuidString: fastAnswer["ID"] as? String ?? "error") ?? UUID(), name: name)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
        if let ropes = userInfo["Ropes"] as? [[String : Any]] {
            for rope in ropes {
                if let name = rope["Name"] as? String {
                    do {
                        try ToDo(name: name, id: UUID(uuidString: rope["ID"] as? String ?? "error") ?? UUID(), auto : false, date_of_creation: rope["Date"] as? Date ?? Date())
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func send(_ Dictionary : [String : Any], RequiresReply : Bool = false) async {
            guard WCSession.default.activationState == .activated else {
                print("is not in activationstate")
              return
            }
            #if os(iOS)
            guard WCSession.default.isWatchAppInstalled else {
                print("is not app")
                return
            }
            #else
            guard WCSession.default.isCompanionAppInstalled else {
                print("is not companion")
                return
            }
            #endif
            
        if !RequiresReply {
#if DEBUG
            WCSession.default.sendMessage(Dictionary, replyHandler: nil) { error in
                print("Cannot send message: \(String(describing: error))")
            }
#else
            let info = WCSession.default.transferUserInfo(Dictionary)
#endif
        } else {
            WCSession.default.sendMessage(Dictionary) { userInfo in
                print("reply session started")
                print(userInfo)
                self.Sync(userInfo)
            }
        }
        print("Sended")
        }
    //aw
}

extension WC: WCSessionDelegate {
    func session(_ session: WCSession, didReceiveUserInfo userInfo: [String : Any] = [:]) {
        summon(userInfo: userInfo)
    }
    func session(_ session: WCSession, didReceiveMessage userInfo: [String : Any] = [:]) {
        summon(userInfo: userInfo)
        }
    func session(_ session: WCSession, didReceiveMessage message: [String : Any], replyHandler: @escaping ([String : Any]) -> Void) {
        print("reply session started")
        print(message)
        let toDos = ToDo.fetch()
        
        // Create a fetch request for a specific Entity type
        let fastAnswers = FastAnswers.fetch()
        
        var syncObjects : [String : [[String : Any]]] = [:]
        syncObjects["FastAnswers"] = []
        for fastAnswer in fastAnswers {
            syncObjects["FastAnswers"]!.append(["Name" : fastAnswer.name, "ID" : fastAnswer.id?.uuidString])
        }
        syncObjects["Ropes"] = []
        for toDo in toDos {
            syncObjects["Ropes"]!.append(["Name" : toDo.name, "ID" : toDo.id?.uuidString, "Date" : toDo.date])
        }
        print("reply back")
        replyHandler(syncObjects)
        print("replyed back")
        DispatchQueue.main.async {
            self.Sync(message)
        }
        print("end")
    }
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {}
    
    #if os(iOS)
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        session.activate() //From guide
    }
    #endif
        func summon (userInfo : [String : Any]) {
            print(userInfo)
            NSLog("Session started")
            // log
            NSLog(userInfo["String"] as? String ?? "No string")
            if let toDo = userInfo["Tasks"] as? ToDo {
                DispatchQueue.main.async { [weak self] in
                    try! ToDo(context: PersistenceController.shared.container.viewContext , name: toDo.name ?? "error", id: toDo.id ?? UUID(), date_of_creation: toDo.date ?? Date(), from_message: true)
                }
            }
            if let text = userInfo["String"] as? String {
                NSLog("Text")
                DispatchQueue.main.async { [weak self] in
                    try! ToDo(context: PersistenceController.shared.container.viewContext, name: text, from_message: true)
                    print(text)
                }
            }
            // log
            if let name = userInfo["Name"] as? String {
                DispatchQueue.main.async { [weak self] in
                    do {
                        try ToDo(name : name, id :UUID(uuidString: (userInfo["ID"] as! String))!, date_of_creation: userInfo["Date"] as! Date,from_message: true)
                    } catch AddingErrors.ThisNameIsExciting {
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            if let id = userInfo["IDForDelete"] as? String {
                DispatchQueue.main.async { [weak self] in
                    do {
                        try ToDo.findByID(id: id).remove(fromConnectivity: true)
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            if let id = userInfo["FastAnswersID"] as? String {
                DispatchQueue.main.async {
                    do {
                        try FastAnswers(id : UUID(uuidString: id)!, name: userInfo["FastAnswersName"] as! String, fromConnectivity: true)
                    } catch AddingErrors.ThisNameIsExciting {
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }
            if let id = userInfo["IDForRemoveFA"] as? String {
                DispatchQueue.main.async {
                    try! FastAnswers.findById(id: id)!.remove(fromConnectivity: true)
                }
            }
            if let time = userInfo["DefautTime"] as? Double {
                var timeObj = Time()
                timeObj.time = time
                print("Time: \(time)")
            }
            NSLog("Session ended")
            }
}
