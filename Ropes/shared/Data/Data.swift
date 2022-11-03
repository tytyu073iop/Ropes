import SwiftUI
import CloudKit

let times : [Double] = [5, 10, 15, 20, 30]

let defaults = UserDefaults.standard

let admin : Bool = {
    #if DEBUG
    return true
    #else
    return false
    #endif
}()
let beta = false

let dateFormater = DateFormatter()

var recordZone : CKRecordZone.ID = CKRecordZone.default().zoneID

//extension CKServerChangeToken : Encodable {
    
//}

var token : CKServerChangeToken? = nil
