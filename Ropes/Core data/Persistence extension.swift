import SwiftUI

extension PersistenceController {
    static func save() {
        let viewContext = PersistenceController.shared.container.viewContext
        do {
            try viewContext.save()
        }
        catch {
            print(error.localizedDescription)
        }
    }
}

extension Task where Success == Never, Failure == Never {
    static func sleep(seconds: Double) async throws {
        let duration = UInt64(seconds * 1_000_000_000)
        try await Task.sleep(nanoseconds: duration)
    }
}
