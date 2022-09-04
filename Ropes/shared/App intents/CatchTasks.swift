//
//  CatchTasks.swift
//  Ropes
//
//  Created by Илья Бирюк on 24.08.22.
//

import SwiftUI
import AppIntents
import CoreData

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *) struct ShowTasks : AppIntent {
    //FIXME: no translation
    static var title: LocalizedStringResource = LocalizedStringResource("Show Ropes", table: "Localizable.strings.")
    static var description = IntentDescription(LocalizedStringResource("Show all tasks from the ropes app", table: "Localizable.strings."))
    func perform() async throws -> some IntentResult {
        // Create a fetch request for a specific Entity type
        let fetchRequest = ToDo.fetchRequest()

        // Get a reference to a NSManagedObjectContext
        let context = PersistenceController.shared.container.viewContext

        // Fetch all objects of one Entity type
        let objects = try context.fetch(fetchRequest)
        
        var names = [String]()
        for object in objects {
            if let toDo = object as? ToDo {
                print("catched")
                names.append(toDo.name ?? "error")
            }
        }
        var phrase : String = LocalizedStringKey("Your Ropes:").stringValue()
        let q : Bool = !names.isEmpty
        //FIXME: if names doesnt contain anything
        if true {
            phrase += " \(names.first!)"
            for name in names {
                if name == names.first! {
                    continue
                }
                phrase += ", \(name)"
            }
            return .result(value: names, dialog: IntentDialog(stringLiteral: phrase))
        } else {
            return .result(value: names, dialog: "You have no ropes")
        }
    }
    
}

struct CatchTasks: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CatchTasks_Previews: PreviewProvider {
    static var previews: some View {
        CatchTasks()
    }
}
