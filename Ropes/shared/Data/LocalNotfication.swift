import SwiftUI
import UserNotifications
import Foundation
import CloudKit

//
extension LocalizedStringKey {
    var stringKey: String? {
        Mirror(reflecting: self).children.first(where: { $0.label == "key" })?.value as? String
    }
}

extension String {
    static func localizedString(for key: String,
                                locale: Locale = .current) -> String {
        
        let language = locale.languageCode
        guard let path = Bundle.main.path(forResource: language, ofType: "lproj") else {
            return "error"
        }
        let bundle = Bundle(path: path)!
        let localizedString = NSLocalizedString(key, bundle: bundle, comment: "")
        
        return localizedString
    }
}

extension LocalizedStringKey {
    func stringValue(locale: Locale = .current) -> String {
        return .localizedString(for: self.stringKey!, locale: locale)
    }
}
//


class LocalNotficationManager:NSObject, ObservableObject {
    let done : LocalizedStringKey = "Done"
    static let shared = LocalNotficationManager()
    private let notficationCenter = UNUserNotificationCenter.current()
    override init() {
        super.init()
        notficationCenter.delegate = self
    }
    //TODO: Change to numerical
    func request(text : String, time : Double = defaults.double(forKey: "time"), userInfo : [AnyHashable : Any]? = nil) throws {
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
        
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:  admin ? time : time * 60, repeats: (admin) ? false : true)
        
        // choose a random identifier
        let request = UNNotificationRequest(identifier: text, content: content, trigger: trigger)
        // add our notification request
        notficationCenter.add(request)
        print("request ended")
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
        let done = UNNotificationAction(identifier: "done", title: done.stringValue())
        //category
        let category = UNNotificationCategory(identifier: "doneCategory", actions: [done], intentIdentifiers: [])
        notficationCenter.setNotificationCategories([category])
    }
}


extension LocalNotficationManager : UNUserNotificationCenterDelegate{
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound,.banner]
    }
    @MainActor func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        //FIXME: actions doesn't working when app closed
        if response.actionIdentifier == "done" {
            if let id = response.notification.request.content.userInfo["id"] as? String {
                // Create a new background managed object context
                let context = PersistenceController.shared.container.viewContext
                
                // If needed, ensure the background context stays
                // up to date with changes from the parent
                context.automaticallyMergesChangesFromParent = true
                // Perform operations on the background context
                // asynchronously
                do {
                    let todo = try ToDo.findByID(id: id, context: context)
                    await todo.remove(context: context, auto: true)
                    try ToDo.findByID(id: "0", context: context)
                } catch {
                }
            }
        }
    }
}

func RemoteNotficationHandler(userInfo : [AnyHashable : Any]) {
    print("recived! \(userInfo)")
    let notfication = CKQueryNotification(fromRemoteNotificationDictionary: userInfo)
    print("notificationType : \(String(describing: notfication?.notificationType))")
    guard notfication?.notificationType == .query else {
    switch notfication?.notificationType {
    case .query:
        print("notificationType: query")
    case .recordZone:
        print("notificationType: recordzone")
    case .database:
        print("notificationType: database")
    case .readNotification:
        print("notificationType: notification")
    case .none:
        print("notificationType: none")
    case .some(_):
        print("notificationType: some")
    }
        print("failed")
        return
    }
    print("recive 2 \(String(describing: notfication))")
    print("recordZone: \(recordZone)")
    switch notfication?.queryNotificationReason {
    case .recordDeleted:
        print("removing")
        CKContainer.default().privateCloudDatabase.fetch(withRecordID: (notfication?.recordID)!) { record, error in
            if let record = record {
                // Handle creating local notif for record
                if record.value(forKey: "CD_entityName") as! String == "ToDo" {
                    let notficationName = record.value(forKey: "CD_name") as! String
                    print("CD_NAme = \(notficationName)")
                    LocalNotficationManager.remove(id: notficationName)
                    print("removed!! \(notficationName)")
                }
            } else if let error = error {
                print("requests: Unable to retrieve record: \(error)")
                Task {
                    await LocalNotficationManager.shared.NotficationCheck()
                }
            }
        }
    default:
        print("queryNotificationReason : \(String(describing: notfication?.queryNotificationReason))")
    }
    var configurations = [CKRecordZone.ID: CKFetchRecordZoneChangesOperation.ZoneConfiguration]()
    let config = CKFetchRecordZoneChangesOperation.ZoneConfiguration()
    config.previousServerChangeToken = token//defaults.object(forKey: recordZone.zoneName) as? CKServerChangeToken
    configurations[recordZone] = config
    let operation = CKFetchRecordZoneChangesOperation( recordZoneIDs: [recordZone], configurationsByRecordZoneID: configurations)
    operation.recordWasChangedBlock = { recordID, result in
        print("record: \(recordID)")
        print("record: \(recordID.recordName)")
        switch result {
        case .failure(let error):
            print("recordWasChangedBlock error :\(error.localizedDescription)")
        case .success(let record):
            for key in record.allKeys() {
                print("recordkey: \(key)")
            }
            if record.value(forKey: "CD_entityName") as! String == "ToDo" {
                let notficationName = record.value(forKey: "CD_name") as! String
                print("CD_NAme = \(notficationName)")
                switch notfication?.queryNotificationReason {
                case .recordCreated:
                    Task {
                        if await !LocalNotficationManager.shared.Contains(id: notficationName) {
                            try! await LocalNotficationManager.shared.request(text: notficationName)
                            print("created!! \(notficationName)")
                        }
                    }
                case .recordDeleted:
                    print("removing")
                    LocalNotficationManager.remove(id: notficationName)
                    print("removed!! \(notficationName)")
                default:
                    print("queryNotificationReason : \(String(describing: notfication?.queryNotificationReason))")
                }
            }
        }
    }
    operation.recordZoneChangeTokensUpdatedBlock = { recordZoneID, tokenToPick, _ in
        print("token : \(String(describing: token))")
        print("recordzoneID.zonename = \(recordZoneID.zoneName)")
        //defaults.set(token, forKey: recordZoneID.zoneName)
        token = tokenToPick
    }
    operation.recordZoneFetchCompletionBlock = { recordZoneID, tokenToPick, _, _, error in
        if let error = error {
            print("blyat: \(error.localizedDescription)")
        } else {
            token = tokenToPick
            print("finished")
            //if let encoded = JSONEncoder().encode(token) {
                //defaults.set(token, forKey: recordZoneID.zoneName)
            //}
        }
    }
    operation.qualityOfService = .userInitiated
    CKContainer.default().privateCloudDatabase.add(operation)
    print("request ended")

}
