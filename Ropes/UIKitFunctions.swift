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

class UIKitFunctions: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        print("willFinishLaunchingWithOptions \(launchOptions)")
        if launchOptions == nil {
            SetUP()

        }
        return true
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) async -> UIBackgroundFetchResult {
        RemoteNotficationHandler(userInfo: userInfo)
        return .newData
    }
}

