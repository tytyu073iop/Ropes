//
//  AllIntents.swift
//  Ropes
//
//  Created by Илья Бирюк on 13.09.22.
//

import Foundation
#if canImport(AppIntents)
import AppIntents

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *) struct RopesShortCuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: ShowTasks(), phrases: ["Show \(.applicationName)"]) ;
        AppShortcut(intent: AddRopeShortcut(), phrases: ["Create a \(.applicationName)"]) ;
        AppShortcut(intent: RemoveRope(), phrases: ["Remove \(.applicationName)"])
    }
    static var shortcutTileColor: ShortcutTileColor = .purple
}
#endif
