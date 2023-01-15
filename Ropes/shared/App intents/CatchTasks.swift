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
        var objects = ToDo.fetch()
        objects = objects.reversed()
        var names = [String]()
        for object in objects {
            names.append(object.name ?? "error")
        }
        var phrase : String = ""
        if !names.isEmpty {
            phrase += " \(names.first!)"
            for name in names {
                if name == names.first! {
                    continue
                }
                phrase += ", \(name)"
            }
            return .result(value: names, dialog: IntentDialog("Your Ropes:\(phrase)"), view: CatchTasks(objects: objects))
        } else {
            return .result(value: names, dialog: "You have no ropes", view: LikeEmptyView())
        }
    }
    
}

struct LikeEmptyView : View {
    var body: some View {
        VStack {
            
        }
    }
}

struct CatchTasks: View {
    let objects : [ToDo]
    var body: some View {
        ForEach(objects) { rope in
            Divider()
            VStack {
                HStack {
                    Spacer()
                    Text(rope.name ?? "error")
                    Spacer()
                }.padding(.top, 0)
                if rope == objects.last {
                    HStack {
                        Spacer()
                        Text(dateFormater.string(from: rope.date ?? Date()))
                        Spacer()
                    }.padding(.bottom, 6)
                } else {
                    HStack {
                        Spacer()
                        Text(dateFormater.string(from: rope.date ?? Date()))
                        Spacer()
                    }
                }
            }
        }
    }
}

#endif
