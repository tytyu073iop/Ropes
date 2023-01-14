//
//  DeleteIntent.swift
//  Ropes
//
//  Created by Илья Бирюк on 17.09.22.
//

import Foundation
import AppIntents
import SwiftUI

@available(iOS 16.0, macOS 13.0, watchOS 9.0, *) struct RemoveRope : AppIntent {
    static var title: LocalizedStringResource = LocalizedStringResource("Remove rope")
    static var description: IntentDescription = IntentDescription(LocalizedStringResource("Removes rope"), searchKeywords: ["delete","clean","erase","clear"])
    static var parameterSummary: some ParameterSummary {
            Summary("Remove a rope \(\.$rope)")
        }
    @Parameter(title: "Rope") var rope : RopeEntity
    func perform() async throws -> some IntentResult {
        print("deleting")
        try await ToDo.findByID(id: rope.id.uuidString).remove()
        return .result()
    }
}
