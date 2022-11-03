//
//  SilentNotfications.swift
//  Ropes
//
//  Created by Илья Бирюк on 24.09.22.
//

import Foundation
import CloudKit

func LoudNotfication() {
    print("Query begin")
    guard true else {
        print("QueryRZ: oh")
        return
        
    }
    let subscription = CKQuerySubscription(recordType: "CD_ToDo", predicate: NSPredicate(value: true),subscriptionID: "RopeLoudCreate")
    subscription.zoneID = recordZone
    print("QueryRZ: \(recordZone)")
    let notficationInfo = CKSubscription.NotificationInfo()
    notficationInfo.alertBody = "Changed"
    notficationInfo.title = "Changed"
    notficationInfo.shouldSendContentAvailable = true
    subscription.notificationInfo = notficationInfo
    
    let operation = CKModifySubscriptionsOperation(subscriptionsToSave: [subscription])
    
    UserDefaults.standard.setValue(true, forKey: "didCreateQuerySubscription")
    
    operation.qualityOfService = .userInitiated
    CKContainer.default().privateCloudDatabase.add(operation)
    print("finish")
}

func predicateSetUp() {
    print("QueryRZ begin")
    guard true else {
        print("QueryRZ: oh")
        LoudNotfication()
        return
        
    }
    let subscription = CKQuerySubscription(recordType: "CD_ToDo", predicate: NSPredicate(value: true),subscriptionID: "RopeCreate")
    subscription.zoneID = recordZone
    print("QueryRZ: \(recordZone)")
    let notficationInfo = CKSubscription.NotificationInfo()
    notficationInfo.shouldSendContentAvailable = true
    subscription.notificationInfo = notficationInfo
    
    let operation = CKModifySubscriptionsOperation(subscriptionsToSave: [subscription])
    
    UserDefaults.standard.setValue(true, forKey: "didCreateQuerySubscription")
    
    operation.qualityOfService = .userInitiated
    CKContainer.default().privateCloudDatabase.add(operation)
    print("finish")
    #if DEBUG
    LoudNotfication()
    #endif
}
