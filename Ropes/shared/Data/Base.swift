import SwiftUI
import Foundation
import WidgetKit

class Time : ObservableObject {
    @AppStorage("time", store : defaults) private var SetTime : Double = 5
    @Published var time : Double = 5 {
        didSet {
            SetTime = time
            Task {
                if #available(watchOS 9.0, *) {
                    print("sending time")
                    NSUbiquitousKeyValueStore.default.set(time, forKey: "time")
                }
                await LocalNotficationManager.shared.moveAll()
            }
        }
    }
    init () {
        time = SetTime
    }
}

class IcloudKeyValue {
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
            Time().time = defaults.double(forKey: "time")
            PopUp().PopUp = defaults.bool(forKey: "popup")
            Swap().Swap = defaults.bool(forKey: "swap")
            return
        }
        let pop = NSUbiquitousKeyValueStore.default.bool(forKey: "popup")
        let t = NSUbiquitousKeyValueStore.default.double(forKey: "time")
        print(t)
        print(pop)
        PopUp().PopUp = pop
        Swap().Swap = NSUbiquitousKeyValueStore.default.bool(forKey: "swap")
        
        if times.contains(t) {
            Time().time = t
        }
        print("sync ended")
    }
}
class PopUp : ObservableObject {
    @AppStorage("popup", store: defaults) private var UDPopUp = false
    @Published var PopUp = false {
        didSet {
            UDPopUp = PopUp
            NSUbiquitousKeyValueStore.default.set(PopUp, forKey: "popup")
        }
    }
    init () {
        PopUp = UDPopUp
    }
}

class Swap : ObservableObject {
    @AppStorage("swap", store: defaults) private var APSwap = true
    @Published var Swap = true {
        didSet {
            APSwap = Swap
            NSUbiquitousKeyValueStore.default.set(Swap, forKey: "swap")
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    init() {
        Swap = APSwap
    }
}

enum NotificationErrors: Error {
    case missingTime
    case noPermition
}

enum AddingErrors : Error , CustomLocalizedStringResourceConvertible{
    var localizedStringResource: LocalizedStringResource {
        switch self{
        case .EmptyName: return "Empty name"
        case .ThisNameIsExciting: return "This name is already exists. Rename in order to continue"
        }
    }
    
    case ThisNameIsExciting, EmptyName
}

enum ProgramErrors : Error {
    case Nil
}
