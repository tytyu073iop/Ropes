//
//  AddIntent.swift
//  Ropes
//
//  Created by Илья Бирюк on 22.08.22.
//

import SwiftUI
#if canImport(AppIntents)
import AppIntents



@available(iOS 16.0, macOS 13.0, watchOS 9.0, *) struct AddTask : AppIntent {
    static var title: LocalizedStringResource = LocalizedStringResource("Add rope", table: "Localizable.strings.")
    static var description = IntentDescription(LocalizedStringResource("Add task to the ropes app", table: "Localizable.strings."))
    @Parameter(title: "Task") var Task: String?
    func perform() async throws -> some IntentResult {
        print(AddTask.title.table)
        if Task == nil {
            Task = LocalizedStringKey("Rope").stringValue()
        }
        let context = PersistenceController.shared.container.viewContext
        var i = 1
        let rawTask = Task
        while true {
            do {
                try await ToDo(context: context, name: Task!)
                break
            } catch AddingErrors.ThisNameIsExciting {
                Task = rawTask
                Task! += String(i)
                i += 1
                print("trying")
            }
        }
        return .result(value: Task ?? "Rope" ,dialog : "Task \(Task ?? "Rope") was created", content: {VStack{}})
    }
    static var parameterSummary: some ParameterSummary {
            Summary("Create a rope \(\.$Task)")
        }
      
        init() {}

        init(Task: String?) {
            self.Task = Task
        }
}

// An AppShortcut turns an Intent into a full fledged shortcut
// AppShortcuts are returned from a struct that implements the AppShortcuts
// protocol



struct MyView: View {
    var body: some View {
        HStack{
            Spacer()
            Text("Task")
            Spacer()
        }
    }
}

struct MyView_Previews: PreviewProvider {
    static var previews: some View {
        MyView()
    }
}

#endif
