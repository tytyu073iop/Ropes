//
//  AllIntents.swift
//  Ropes
//
//  Created by Илья Бирюк on 13.09.22.
//

import Foundation
import AppIntents

struct RopesShortCuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: AddRopeShortcut(), phrases: ["Create a \(.applicationName)", "Create the \(.applicationName)", "Create \(.applicationName)", "make a \(.applicationName)", "make the \(.applicationName)", "make \(.applicationName)", "add \(.applicationName)", "add a \(.applicationName)", "add the \(.applicationName)"], shortTitle: "new task", systemImageName: "plus") ;
        AppShortcut(intent: ShowTasks(), phrases: ["Show \(.applicationName)", "Show my \(.applicationName)"], shortTitle: "Show tasks", systemImageName: "list.bullet")
    }
}
