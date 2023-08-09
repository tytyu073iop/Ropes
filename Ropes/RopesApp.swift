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
    #if os(iOS)
    @UIApplicationDelegateAdaptor private var appDelegate: UIKitFunctions
    #endif
    #if os(watchOS)
    @WKApplicationDelegateAdaptor var appDelegate: WatchKitFunctions
    #endif
    #if os(macOS)
    @NSApplicationDelegateAdaptor var appDelegate: NSApplicationDelegateFunctions
    #endif
    
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        #if os(macOS)
        #endif
    }
}
