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

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *) struct AddCustomTask : AppIntent {
    static var title: LocalizedStringResource = LocalizedStringResource("Add custom rope", table: "Localizable.strings.")
    static var description = IntentDescription(LocalizedStringResource("Add task to the ropes app", table: "Localizable.strings."))
    @Parameter(title: "Task") var Task: String
    func perform() async throws -> some IntentResult {
        print(AddTask.title.table ?? "Intent error")
        if Task == nil {
            Task = LocalizedStringKey("Rope").stringValue()
        }
        let context = PersistenceController.shared.container.viewContext
        var i = 1
        let rawTask = Task
        while true {
            do {
                try await ToDo(context: context, name: Task)
                break
            } catch AddingErrors.ThisNameIsExciting {
                Task = rawTask
                Task += String(i)
                i += 1
                print("trying")
            }
        }
        return .result(value: Task ,dialog : "Task \(Task) was created", content: {VStack{}})
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
