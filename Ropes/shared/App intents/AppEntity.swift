//
//  AppEntity.swift
//  Ropes
//
//  Created by Илья Бирюк on 17.09.22.
//

import Foundation
import AppIntents

///ToDo entity for AppIntents
struct RopeEntity : AppEntity, Hashable {
    ///How name of type displays
    static var typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(name: "Rope")
    
    ///From what items to select
    static var defaultQuery = RopeQuiery()
    var id : UUID
    //TODO: more complicted shortcut type
//    var date : Date
    ///
    static var typeDisplayName : LocalizedStringResource = "Rope"
    var name : String
    ///How type displays as a result and select
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)",subtitle: "")
    }
}

///Shows from what to chose
struct RopeQuiery : EntityQuery {
    ///- returns: entites which suits the chose. Shows interface of chose when more than one option
    func entities(for identifiers: [UUID]) throws -> [RopeEntity] {
        let request = ToDo.fetchRequest()
        request.returnsObjectsAsFaults = false
        var result = try! PersistenceController.shared.container.newBackgroundContext().fetch(request) as [ToDo]
        result.reverse()
        return result.filter { todo in
            identifiers.contains { id in
                id == todo.id
            }
        }.map { todo in
            RopeEntity(id: todo.id ?? UUID(), name: todo.name ?? "error")
        }
    }
    ///- returns:All ToDos
    func suggestedEntities() async throws -> [RopeEntity] {
        let request = ToDo.fetchRequest()
        request.returnsObjectsAsFaults = false
        var result = try! PersistenceController.shared.container.newBackgroundContext().fetch(request) as [ToDo]
        result.reverse()
        return result.map { todo in
            return RopeEntity(id: todo.id ?? UUID() , name: todo.name ?? "error")
        }
    }
}

extension RopeEntity : Identifiable {
    
}
