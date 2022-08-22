//
//  AddIntent.swift
//  Ropes
//
//  Created by Илья Бирюк on 22.08.22.
//

import SwiftUI
#if canImport(AppIntents)
import AppIntents
#endif

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *) struct AddTask : AppIntent {
    static var title: LocalizedStringResource = "Add Task"
    static var description = IntentDescription("Add task to the ropes app")
    @Parameter(title: "Task") var Task: String?
    func perform() async throws -> some IntentResult {
        let context = PersistenceController.shared.container.viewContext
        await ToDo(context: context, name: Task ?? "Rope")
        return .result()
    }
}
