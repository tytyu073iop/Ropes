//
//  CatchTasks.swift
//  Ropes
//
//  Created by Илья Бирюк on 24.08.22.
//

import SwiftUI
#if canImport(AppIntents)
import AppIntents
import CoreData

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *) struct ShowTasks : AppIntent {
    //FIXME: no translation
    static var title: LocalizedStringResource = LocalizedStringResource("Show Ropes")
    static var description = IntentDescription(LocalizedStringResource("Show all tasks from the ropes app"))
    func perform() async throws -> some IntentResult {
        let objects = ToDo.fetch()
        var names = [String]()
        for object in objects {
            print("catched")
            names.append(object.name ?? "error")
        }
        var phrase : String = String(localized: LocalizedStringResource("Your Ropes:"))
        if !names.isEmpty {
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

#endif
