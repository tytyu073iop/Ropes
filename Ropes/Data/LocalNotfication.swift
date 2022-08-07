import SwiftUI
import UserNotifications
import NotificationCenter

@MainActor
class LocalNotficationManager:NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    @Published var isGranted = false
    static let shared = LocalNotficationManager()
    private let notficationCenter = UNUserNotificationCenter.current()
    override init() {
        super.init()
        notficationCenter.delegate = self
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound,.banner]
    }
    func request(text : String, time : any Numeric, id : UUID = UUID()){
        let content = UNMutableNotificationContent()
        content.title = text
        content.interruptionLevel = .timeSensitive
        content.sound = .default
        
        // show this notification five seconds from now
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval:  admin ? time as! Double : time as! Double * 60, repeats: (admin) ? false : true)
        
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
    func openSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                Task {
                    await UIApplication.shared.open(url)
                }
            }
        }
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
    func PrintRequests() async {
        var requests = await UNUserNotificationCenter.current().pendingNotificationRequests()
        print(requests.count)
        for request in requests {
            print(request.trigger as? UNTimeIntervalNotificationTrigger)
        }
    }
}
