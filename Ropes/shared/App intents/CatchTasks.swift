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
    static var title: LocalizedStringResource = "Show Ropes"
    static var description = IntentDescription("Add task to the ropes app")
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
                names.append(toDo.name)
            }
        }
        return .result(value: names)
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
