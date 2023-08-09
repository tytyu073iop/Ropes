import SwiftUI
import UserNotifications
import Foundation
import CloudKit
import CoreData

class LocalNotficationManager:NSObject, ObservableObject {
    let done : String = String(localized: LocalizedStringResource("Done"))
    static let shared = LocalNotficationManager()
    private let notficationCenter = UNUserNotificationCenter.current()
    override init() {
        super.init()
        //notficationCenter.delegate = 
    }
    //TODO: Change to numerical
    func request(text : String, time : Double = defaults.double(forKey: "time"), userInfo : [AnyHashable : Any]? = nil, id: String) {
        //test
        print("requesting")
        //test
        registerCategory()
        let content = UNMutableNotificationContent()
        content.title = text
        content.interruptionLevel = .timeSensitive
        content.sound = .default
        content.categoryIdentifier = "doneCategory"
        if userInfo != nil{
            content.userInfo = userInfo!
        }
        content.userInfo["id"] = id
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:  admin ? time : time * 60, repeats: (admin) ? false : true)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: text, content: content, trigger: trigger)
        // add our notification request
        notficationCenter.add(request)
    }
    func request(text : String, time : Date, id : UUID = UUID()) throws {
        
        let content = UNMutableNotificationContent()
        content.title = text
        content.interruptionLevel = .timeSensitive
        content.sound = .default
        
        // show this notification five seconds from now
        if time.timeIntervalSinceNow <= 0 {
            throw NotificationErrors.missingTime
        }
        let trigger = UNCalendarNotificationTrigger(dateMatching: Calendar.current.dateComponents([.hour,.minute], from: time), repeats: admin ? false : true)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: text, content: content, trigger: trigger)
        // add our notification request
        notficationCenter.add(request)
    }
    func requestAuthorization(Options : UNAuthorizationOptions = [.sound,.alert,.badge]) async throws{
        try await notficationCenter.requestAuthorization(options: Options)
    }
    private func isGrantedAsFunc() async -> Bool {
        let currentSettings = await notficationCenter.notificationSettings()
        return (currentSettings.authorizationStatus == .authorized)
    }
    static func remove(id : String) {
        print("removing \(id)")
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
}

extension LocalNotficationManager {
    func moveAll (time : Double = defaults.double(forKey: "time")) async {
        let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
        var copyOfRequests : [UNNotificationRequest] = []
        print(requests.count)
        for request in requests {
            if var timeInterval = request.trigger as? UNTimeIntervalNotificationTrigger {
                timeInterval = UNTimeIntervalNotificationTrigger(timeInterval: admin ? time : time*60, repeats: admin ? false : true)
                copyOfRequests.append(UNNotificationRequest(identifier: request.identifier, content: request.content, trigger: timeInterval))
                print("afther change")
            }
        }
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        for copyOfRequest in copyOfRequests {
            try? await notficationCenter.add(copyOfRequest)
        }
    }
    func NotficationCheck() async {
        print("requests: begin checking")
        var arr : [String] = []
        let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
        let privateDB = CKContainer.default().privateCloudDatabase
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "CD_ToDo", predicate: predicate)
        privateDB.fetch(withQuery: query) { result in
            print("NCQ \(result)")
            switch result {
            case .success((let matchResults, let queryCursor)):
                print(" afther \(matchResults)")
                for (recordID, res) in matchResults {
                    switch res {
                    case .success(let record):
                        print("afther: \(record.value(forKey: "CD_name") as! String))")
                        arr.append(record.value(forKey: "CD_name") as! String)
                        print("afther: \(arr)")
                    case .failure(_):
                        print("afther falure")
                    }
                    print("NCQ: \(res)")
                }
            case .failure(_):
                print("NCerror")
            }
            print("afther: requests: arr: \(arr) req: \(requests)")
            print("requests: pair: arr: \(arr.count) req: \(requests.count)")
            var idForDelete = requests.compactMap { request in
                if !arr.contains(where: { name in
                    request.identifier == name
                }) {
                    return request.identifier
                } else {
                    return nil
                }
            }
            print("idfordel \(idForDelete)")
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: idForDelete)
        }
        print("requests: pair: arr: \(arr.count) req: \(requests.count)")
    }
    //TODO: Change to numerical
    func PrintRequests() async {
        let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
        print("requests: count: \(requests.count)")
        for request in requests {
            print("requests: Pending request: \(request.identifier)")
        }
    }
    func Contains(id : String) async -> Bool {
        let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
        print(requests.count)
        for request in requests {
            print("Pending request: \(request)")
            if request.identifier == id {
                return true
            }
        }
        return false
    }
    func registerCategory() {
        //actions
        let done = UNNotificationAction(identifier: "done", title: done)
        //category
        let category = UNNotificationCategory(identifier: "doneCategory", actions: [done], intentIdentifiers: [])
        notficationCenter.setNotificationCategories([category])
    }
}


extension LocalNotficationManager : UNUserNotificationCenterDelegate{
   

}
