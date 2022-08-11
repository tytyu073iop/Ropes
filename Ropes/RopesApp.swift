//
//  RopesApp.swift
//  Ropes
//
//  Created by Илья Бирюк on 7.08.22.
//

import SwiftUI

@main
struct RopesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        #if os(macOS)
        WindowGroup("Adding") {
            Adding()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }.handlesExternalEvents(matching:Set (arrayLiteral: "*"))
        Settings{
            settin()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        #endif
    }
}
