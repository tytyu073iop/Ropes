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

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *) struct FastAnswersEntity : AppEntity {
    static var typeDisplayRepresentation: TypeDisplayRepresentation = TypeDisplayRepresentation(name: "Fast Answer")
    
    static var defaultQuery = FastAnswerQuiery()
    var id : UUID
    static var typeDisplayName : LocalizedStringResource = "Fast Answer"
    var name : String
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}

let CustomsName : LocalizedStringResource = "Custom"

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *) struct FastAnswerQuiery : EntityQuery {
    func entities(for identifiers: [UUID]) async throws -> [FastAnswersEntity] {
        let fas = FastAnswers.fetch()
        var faes = fas.filter { fa in
            identifiers.contains { id in
                id == fa.id
            }
        }.map { fa in
            FastAnswersEntity(id: fa.id!, name: fa.name!)
        }
        if faes.isEmpty {
            faes.append(FastAnswersEntity(id: UUID(uuidString: "49C8D21E-ADAF-4CDD-81DD-07B82C2A99C2")!, name: "Custom"))
        }
        return faes
    }
    
    func suggestedEntities() async throws -> [FastAnswersEntity] {
        let fas = FastAnswers.fetch()
        var faes = fas.map { fa in
            FastAnswersEntity(id: fa.id ?? UUID() ,name: fa.name ?? "error")
        }
        faes.append(FastAnswersEntity(id: UUID(uuidString: "49C8D21E-ADAF-4CDD-81DD-07B82C2A99C2")!, name: String(localized: CustomsName)))
        return faes
    }
    
}
#endif
