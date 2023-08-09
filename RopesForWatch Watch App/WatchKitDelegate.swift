//
//  WatchKitDelegate.swift
//  RopesForWatch Watch App
//
//  Created by Илья Бирюк on 3.11.22.
//

import Foundation
import WatchKit
import UserNotifications
import UIKit
import CoreData

class WatchKitFunctions: NSObject, WKApplicationDelegate, UNUserNotificationCenterDelegate {
    func applicationDidFinishLaunching() -> Void {
        if ProcessInfo.processInfo.arguments.contains("clean") {
            let context = PersistenceController.shared.container.viewContext
            for result in try! context.fetch(ToDo.fetchRequest()) as! [NSManagedObject] {
                context.delete(result)
            }
            for result in try! context.fetch(FastAnswers.fetchRequest()) as! [NSManagedObject] {
                context.delete(result)
            }
        }
        if ProcessInfo.processInfo.arguments.contains("ReqiresR") {
            try! ToDo(name: "Test")
        }
        if ProcessInfo.processInfo.arguments.contains("RequiresFA") {
            try! FastAnswers(name: "Test")
        }
        UNUserNotificationCenter.current().delegate = self
    }
    func didReceiveRemoteNotification(_ userInfo: [AnyHashable : Any]) async -> WKBackgroundFetchResult {
          return .newData
    }
    @MainActor func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        //FIXME: actions doesn't working when app closed
        NSLog("Performing notfication")
        if response.actionIdentifier == "done" {
            if let id = response.notification.request.content.userInfo["id"] as? String {
                await PersistenceController.shared.container.performBackgroundTask { context in
                    var request = ToDo.fetchRequest()
                    request.predicate = NSPredicate(format: "%K = %@", "id", UUID(uuidString: id)! as CVarArg)
                    request.fetchLimit = 1
                    try! context.deleteWithSave(context.fetch(request).first! as! NSManagedObject)
                }
            }
        }
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.sound,.banner]
    }
}
