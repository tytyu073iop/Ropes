//
//  AddCustomIntent.swift
//  Ropes
//
//  Created by Илья Бирюк on 13.09.22.
//

import Foundation
#if canImport(AppIntents)
import AppIntents
import SwiftUI

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *) struct AddRopeShortcut : AppIntent {
    static var title: LocalizedStringResource = LocalizedStringResource("Add rope")
    static var description = IntentDescription(LocalizedStringResource("Add task to the ropes app"))
    @Parameter(title: "Task") var Task: String
    func perform() async throws -> some IntentResult {
        let context = PersistenceController.shared.container.viewContext
        try ToDo(context: context, name: Task)
        return .result()
    }
    static var parameterSummary: some ParameterSummary {
            Summary("Create a rope \(\.$Task)")
        }
      
        init() {}

        init(Task: String) {
            self.Task = Task
        }
}
#endif
