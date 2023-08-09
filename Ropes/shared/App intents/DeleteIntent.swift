//
//  DeleteIntent.swift
//  Ropes
//
//  Created by Илья Бирюк on 17.09.22.
//

import Foundation
import AppIntents
import SwiftUI
import CoreData
///Intent which deletes entity that have been chossen by a user
struct RemoveRope : AppIntent {
    static var title: LocalizedStringResource = LocalizedStringResource("Remove rope")
    static var description: IntentDescription = IntentDescription(LocalizedStringResource("Removes rope"), searchKeywords: ["delete","clean","erase","clear"])
    static var parameterSummary: some ParameterSummary {
            Summary("Remove a rope \(\.$rope)")
        }
    @Parameter(title: "Rope")
    var rope : RopeEntity
    init() {
        
    }
    init(rope: RopeEntity) {
        self.rope = rope
    }
    func perform() async throws -> some IntentResult {
        print("deleting")
        try await PersistenceController.shared.container.performBackgroundTask { context in
            var request = ToDo.fetchRequest()
            request.predicate = NSPredicate(format: "%K == %@", "id", rope.id as CVarArg)
            let result = try! context.fetch(request)
            context.deleteWithSave(result.first! as! NSManagedObject)
        }
        return .result()
    }
}
