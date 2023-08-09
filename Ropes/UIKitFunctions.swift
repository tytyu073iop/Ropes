//
//  UIKitFunctions.swift
//  Ropes
//
//  Created by Илья Бирюк on 3.11.22.
//

import Foundation
import UIKit
import CloudKit
import WidgetKit
import UserNotifications
import CoreData

///Use this class to execute UIKit finctions
class UIKitFunctions: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate{
    ///Starts with the application. Don't use
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
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
        if launchOptions == nil {
            SetUP()

        }
	        return true
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    @MainActor func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
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
    ///Starts when recives remote notfication. Don't use.
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        NSLog("remote")
        return .newData
    }
}

