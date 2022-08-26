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

//FIXME: if closed no notfication
@available(iOS 16.0, macOS 13.0, watchOS 9.0, *) struct AddTask : AppIntent {
    static var title: LocalizedStringResource = LocalizedStringResource("Add rope")
    static var description = IntentDescription("Add task to the ropes app")
    @Parameter(title: "Task") var Task: String?
    func perform() async throws -> some ProvidesDialog {
        print(AddTask.title.table)
        if Task == nil {
            Task = "Rope"
        }
        let context = PersistenceController.shared.container.viewContext
        do {
            //FIXME: when closed do not response
            try await ToDo(context: context, name: Task!)
        } catch NotificationErrors.noPermition {
            return .result( dialog : "You aren't allowed notfications. Add first task right from the app" )
        }
        return .result(dialog : "Task \(Task ?? "Rope") was created")
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

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *) struct RopesShortCuts: AppShortcutsProvider {
    //FIXME: add multiple shortcuts
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddTask(),
            phrases: ["Create a \(.applicationName)"]
        )
    }
}

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
