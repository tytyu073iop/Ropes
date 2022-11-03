import SwiftUI
import Foundation

class Time : ObservableObject {
    @AppStorage("time", store : defaults) private var SetTime : Double = 10
    @Published var time : Double = 10 {
        didSet {
            SetTime = time
            Task {
                if #available(watchOS 9.0, *) {
                    print("sending time")
                    NSUbiquitousKeyValueStore.default.set(time, forKey: "time")
                }
                await LocalNotficationManager.shared.moveAll()
                #if os(iOS)
                await WC.shared.send(["DefautTime" : time])
                #endif
            }
        }
    }
    init (DefaultTime : Double = 10) {
        time = SetTime
    }
}

@available(iOS 15.0, watchOS 9.0, macOS 12.0, *) class IcloudKeyValue {
    static func PrepareICloudKeyValue() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(KeyValueStoreDidChange(_:)),
                                               name: NSUbiquitousKeyValueStore.didChangeExternallyNotification,
                                               object: NSUbiquitousKeyValueStore.default)
        if NSUbiquitousKeyValueStore.default.synchronize() == false {
            print("key blyat")
        }
    }
    
    @objc static func KeyValueStoreDidChange(_ notification : Notification) {
        print("cecking0")
        /** We get more information from the notification, by using:
            NSUbiquitousKeyValueStoreChangeReasonKey or NSUbiquitousKeyValueStoreChangedKeysKey
            constants on the notification's useInfo.
         */
        guard let userInfo = notification.userInfo else { return }
        
        // Get the reason for the notification (initial download, external change or quota violation change).
        guard let reasonForChange = userInfo[NSUbiquitousKeyValueStoreChangeReasonKey] as? Int else { return }
        
        guard let keys =
            userInfo[NSUbiquitousKeyValueStoreChangedKeysKey] as? [String] else { return }
        print("cecking")
        if !(keys.contains("popup") || keys.contains("time")) { return }
        print("Sync begin")
        if reasonForChange == NSUbiquitousKeyValueStoreAccountChange {
            // User changed account, so fall back to use UserDefaults (last color saved).
            Time().time = UserDefaults.standard.double(forKey: "time")
            PopUp().PopUp = defaults.bool(forKey: "popup")
            return
        }
        let pop = NSUbiquitousKeyValueStore.default.bool(forKey: "popup")
        let t = NSUbiquitousKeyValueStore.default.double(forKey: "time")
        print(t)
        print(pop)
        PopUp().PopUp = pop
        
        if times.contains(t) {
            Time().time = t
        }
        print("sync ended")
    }
}
class PopUp : ObservableObject {
    @AppStorage("popup") private var UDPopUp = false
    @Published var PopUp = false {
        didSet {
            UDPopUp = PopUp
            if #available(watchOS 9.0, *) {
                print("sending popup")
                NSUbiquitousKeyValueStore.default.set(PopUp, forKey: "popup")
            }
        }
    }
    init () {
        PopUp = UDPopUp
    }
}

enum NotificationErrors: Error {
    case missingTime
    case noPermition
}

enum AddingErrors : Error {
    case ThisNameIsExciting, EmptyName
}

enum ProgramErrors : Error {
    case Nil
}
