//
//  WatchKitDelegate.swift
//  RopesForWatch Watch App
//
//  Created by Илья Бирюк on 3.11.22.
//

import Foundation
import WatchKit

class WatchKitFunctions: NSObject, WKApplicationDelegate {
    func didReceiveRemoteNotification(_ userInfo: [AnyHashable : Any]) async -> WKBackgroundFetchResult {
        RemoteNotficationHandler(userInfo: userInfo)
        return .newData
    }
}
