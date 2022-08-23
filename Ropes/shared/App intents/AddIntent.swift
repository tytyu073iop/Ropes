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
    static var title: LocalizedStringResource = "Add Rope"
    static var description = IntentDescription("Add task to the ropes app")
    @Parameter(title: "Task") var Task: String?
    func perform() async throws -> some IntentResult {
        let context = PersistenceController.shared.container.viewContext
        do {
            try await ToDo(context: context, name: Task ?? "Rope")
        } catch NotificationErrors.noPermition {
            return .result(content: {
                //FIXME: add an error
                Text("You aren't allowed notfications. Add first task right from the app")
            })
        }
        return .result(content: {
            VStack{
                HStack{
                    Spacer()
                    Text("Task Created!")
                    Spacer()
                }
                HStack{
                    let _ = print("Sucsess!")
                    Spacer()
                    Text(Task ?? "Rope")
                    Spacer()
                }
            }
        })
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
