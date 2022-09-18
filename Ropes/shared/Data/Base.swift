import SwiftUI

class Time : ObservableObject {
    @AppStorage("time", store : defaults) private var SetTime : Double = 10
    @Published var time : Double = 10 {
        didSet {
            SetTime = time
            Task {
                await LocalNotficationManager.shared.moveAll()
                #if os(iOS)
                await WC.shared.send(["DefautTime" : time])
                #endif
            }
        }
    }
    init (DefaultTime : Double = 10) {
        time = SetTime
    }
}

class PopUp : ObservableObject {
    @AppStorage("popup") private var UDPopUp = false
    @Published var PopUp = false {
        didSet {
            UDPopUp = PopUp
        }
    }
    init () {
        PopUp = UDPopUp
    }
}

enum NotificationErrors: Error {
    case missingTime
    case noPermition
}

enum AddingErrors : Error {
    case ThisNameIsExciting, EmptyName
}

enum ProgramErrors : Error {
    case Nil
}
