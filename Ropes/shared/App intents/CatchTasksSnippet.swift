//
//  CatchTasks.swift
//  Ropes
//
//  Created by Илья Бирюк on 24.08.22.
//

import SwiftUI
import AppIntents
import CoreData
///Shortcut intent. Don't use.
struct ShowTasks : AppIntent {
    static var title: LocalizedStringResource = LocalizedStringResource("Show Ropes")
    static var description = IntentDescription(LocalizedStringResource("Show all tasks from the ropes app"))
    func perform() async throws -> some ReturnsValue<[RopeEntity]> & ProvidesDialog & ShowsSnippetView {
        let query = RopeQuiery()
        var objects = try! await query.suggestedEntities()
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
            return .result(value: objects, dialog: IntentDialog("Your Ropes:\(phrase)"), view: CatchTasks(objects: objects))
        } else {
            return .result(value: objects, dialog: "You have no ropes", view: LikeEmptyView())
        }
    }
    
}

///Use it to return empty view
struct LikeEmptyView : View {
    var body: some View {
        VStack {
            
        }
    }
}

///View of catch tasks intent
struct CatchTasks: View {
    let objects : [RopeEntity]
    var body: some View {
        ForEach(objects) { rope in
            Divider()
            VStack {
                HStack {
                    Spacer()
                    Text(rope.name)
                    Spacer()
                }.padding(.top, 0)
                if rope.id == objects.last?.id {
                    HStack {
                        Spacer()
                        Spacer()
                    }.padding(.bottom, 6)
                } else {
                    HStack {
                        Spacer()
                        Spacer()
                    }
                }
            }
        }
    }
}
