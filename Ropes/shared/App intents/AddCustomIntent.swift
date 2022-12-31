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
    @Parameter(title: "Task") var Task: String?
    @Parameter(title: "Select rope") var rope : FastAnswersEntity?
    func perform() async throws -> some IntentResult {
        if Task == nil {
            rope = try await $rope.requestValue()
            if rope!.id == UUID(uuidString: "49C8D21E-ADAF-4CDD-81DD-07B82C2A99C2")! {
                Task = try await $Task.requestValue()
            } else {
                Task = rope!.name
            }
        }
        let context = PersistenceController.shared.container.viewContext
        try await ToDo(context: context, name: Task!)
        return .result(value: Task ,dialog : "Task \(Task!) was created", content: {VStack{}})
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
