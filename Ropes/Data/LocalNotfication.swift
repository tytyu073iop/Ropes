import SwiftUI
import UserNotifications

@MainActor
class LocalNotficationManager:NSObject, ObservableObject {
    @Published var isGranted = false
    static let shared = LocalNotficationManager()
    private let notficationCenter = UNUserNotificationCenter.current()
    override init() {
        super.init()
        notficationCenter.delegate = self
    }
    //TODO: Change to numerical
    func request(text : String, time : Double, id : UUID = UUID(), userInfo : [AnyHashable : Any]? = nil){
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
    func requestAuthorization(Options : UNAuthorizationOptions) async throws{
        try await notficationCenter.requestAuthorization(options: Options)
        isGranted = await isGrantedAsFunc()
    }
    private func isGrantedAsFunc() async -> Bool {
        let currentSettings = await notficationCenter.notificationSettings()
        return (currentSettings.authorizationStatus == .authorized)
    }
    func updatePermition() async {
        isGranted = await isGrantedAsFunc()
    }
    #if os(iOS)
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                Task {
                    await UIApplication.shared.open(url)
                }
            }
        }
    }
    #endif
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
                timeInterval = UNTimeIntervalNotificationTrigger(timeInterval: time*60, repeats: admin ? false : true)
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
        let done = UNNotificationAction(identifier: "done", title: "Done")
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
        //FIX ME: actions doesn't working when app closed
        print("did recive!")
        if response.actionIdentifier == "done" {
            if let id = response.notification.request.content.userInfo["id"] as? String {
                // Create a new background managed object context
                let context = PersistenceController.shared.container.newBackgroundContext()
                
                // If needed, ensure the background context stays
                // up to date with changes from the parent
                context.automaticallyMergesChangesFromParent = true
                
                // Perform operations on the background context
                // asynchronously
                await context.perform {
                    do {
                        let todo = try ToDo.findByID(id: id, context: context)
                        print("remowing")
                        todo.remove(context: context)
                    } catch {
                        print("Блять")
                    }
                }
            }
        }
        print("досвидания")
    }
}
