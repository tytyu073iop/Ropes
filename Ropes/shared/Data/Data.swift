import SwiftUI

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
