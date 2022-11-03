//
//  AppEntity.swift
//  Ropes
//
//  Created by Илья Бирюк on 17.09.22.
//

import Foundation
#if canImport(AppIntents)
import AppIntents

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *) struct RopeEntity : AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(name: "Rope")
    
    
    static var defaultQuery = RopeQuiery()
    var id : UUID
    static var typeDisplayName : LocalizedStringResource = "Rope"
    var name : String
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *) struct RopeQuiery : EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [RopeEntity] {
        NSLog("Quiering")
        let todos = ToDo.fetch()
        return todos.filter { todo in
            identifiers.contains { id in
                id == todo.id
            }
        }.map { todo in
            RopeEntity(id: todo.id!, name: todo.name!)
        }
    }
    
    func suggestedEntities() async throws -> [RopeEntity] {
        NSLog("Suggest Quiering")
        let todos = ToDo.fetch()
        return todos.map { todo in
            RopeEntity(id: todo.id!, name: todo.name ?? "error")
        }
    }
}
#endif
