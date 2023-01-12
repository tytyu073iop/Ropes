//
//  SetUp.swift
//  Ropes
//
//  Created by Илья Бирюк on 3.11.22.
//

import Foundation
import WidgetKit
import CloudKit


func SetUP() {
UserSetUp()
if #available(watchOS 9.0, *) {
    WidgetCenter.shared.reloadAllTimelines()
    IcloudKeyValue.PrepareICloudKeyValue()
}
let fetchZones = CKFetchRecordZonesOperation.fetchAllRecordZonesOperation()
fetchZones.fetchRecordZonesCompletionBlock = { dic, error in
    
    if error != nil {
        print("func : \(String(describing: error))")
    } else {
        for (id, _) in dic! {
            print("id = \(id)")
            if id.zoneName == "com.apple.coredata.cloudkit.zone" {
                recordZone = id
                predicateSetUp()
                
            }
        }
    }
}
fetchZones.qualityOfService = .utility
CKContainer.default().privateCloudDatabase.add(fetchZones)
}

func UserSetUp() {
    dateFormater.dateStyle = .short
    dateFormater.timeStyle = .short
    if defaults.double(forKey: "time") == 0.0 {
        #if DEBUG
        defaults.set(Double(10), forKey: "time")
        #else
        defaults.set(Double(5), forKey: "time")
        #endif
    }
}
