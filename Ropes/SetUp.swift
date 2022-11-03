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
    #if !os(macOS)
WC.shared
    #endif
UserSetUp()
if #available(watchOS 9.0, *) {
    WidgetCenter.shared.reloadAllTimelines()
    IcloudKeyValue.PrepareICloudKeyValue()
}
let fetchZones = CKFetchRecordZonesOperation.fetchAllRecordZonesOperation()
print("database: \(fetchZones.database)")
    print("bbbbb")
fetchZones.fetchRecordZonesCompletionBlock = { dic, error in
    
    if error != nil {
        print("func : \(String(describing: error))")
    } else {
        print("fetch begun: \(dic)")
        for (id, _) in dic! {
            print("id = \(id)")
            if id.zoneName == "com.apple.coredata.cloudkit.zone" {
                recordZone = id
                print("predicateSetUp()")
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
    print("Begining set-up")
    if defaults.double(forKey: "time") == 0.0 { defaults.set(Double(10), forKey: "time")}
    print("set-up completed")
}