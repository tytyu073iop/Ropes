import SwiftUI
import UserNotifications
import Foundation

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

@MainActor
class LocalNotficationManager:NSObject, ObservableObject {
    let done : LocalizedStringKey = "Done"
    static let shared = LocalNotficationManager()
    private let notficationCenter = UNUserNotificationCenter.current()
    override init() {
        super.init()
        notficationCenter.delegate = self
    }
    //TODO: Change to numerical
    func request(text : String, time : Double, id : UUID = UUID(), userInfo : [AnyHashable : Any]? = nil) throws {
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
    //TODO: Change to numerical
    func PrintRequests() async {
        let requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
        print(requests.count)
        for request in requests {
            print(request.trigger as? UNTimeIntervalNotificationTrigger)
        }
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
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        //FIXME: actions doesn't working when app closed
        print("did recive!")
        if response.actionIdentifier == "done" {
            print("Stage1")
            NSLog("Notfication responce for category done. Stage one", 12)
            if let id = response.notification.request.content.userInfo["id"] as? String {
                print("Stage2")
                NSLog("Notfication responce for category done. Stage two. ID: ", 12)
                NSLog(id)
                // Create a new background managed object context
                let context = PersistenceController.shared.container.newBackgroundContext()
                
                // If needed, ensure the background context stays
                // up to date with changes from the parent
                context.automaticallyMergesChangesFromParent = true
                // Perform operations on the background context
                // asynchronously
                do {
                    let todo = try ToDo.findByID(id: id, context: context)
                    print("remowing")
                    NSLog("removing")
                    todo.remove(context: context, auto: true)
                    try ToDo.findByID(id: "0", context: context)
                } catch {
                    print("Блять")
                }
            }
        }
        print("досвидания")
        NSLog("END")
    }
}
