//
//  AddCustomIntent.swift
//  Ropes
//
//  Created by Илья Бирюк on 13.09.22.
//

import Foundation
import AppIntents
import SwiftUI

struct AddRopeShortcut : AppIntent {
    static var title: LocalizedStringResource = LocalizedStringResource("Add rope")
    static var description = IntentDescription(LocalizedStringResource("Add task to the ropes app"), searchKeywords: ["append"])
    @Parameter(title: "Task") var Task: String
    func perform() async throws -> some ProvidesDialog & ShowsSnippetView {
        let context = PersistenceController.shared.container.viewContext
        let rope = await try ToDo(context: context, name: Task)
        return .result(dialog: IntentDialog("Rope \(Task) was created")) {
            VStack {
                HStack {
                    Spacer()
                    Text(Task)
                    Spacer()
                }.padding(.top, 5)
                HStack {
                    Spacer()
                    Text(dateFormater.string(from: rope.date ?? Date()))
                    Spacer()
                }.padding(.bottom, 5)
            }
        }
    }
    static var parameterSummary: some ParameterSummary {
            Summary("Create a rope \(\.$Task)")
        }
      
        init() {}

        init(Task: String) {
            self.Task = Task
        }
}
