//
//  NSApplicationDelegate.swift
//  Ropes
//
//  Created by Илья Бирюк on 3.11.22.
//

import Foundation
import AppKit

class NSApplicationDelegateFunctions: NSObject, NSApplicationDelegate {
    func applicationWillFinishLaunching(_ notification: Notification) {
        SetUP()
    }
    func application(_ application: NSApplication, didReceiveRemoteNotification userInfo: [String : Any]) {
        RemoteNotficationHandler(userInfo: userInfo)
    }
}
