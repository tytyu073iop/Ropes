import SwiftUI
import CoreData

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
protocol fetchable : NSManagedObject {}
extension fetchable {
    static func fetch() -> Array<Self> {
        typealias T = Self
        print(T.self)
        let fetchRequest = T.fetchRequest()
        let context = PersistenceController.shared.container.viewContext

        // Fetch all objects of one Entity type
        let objects = try! context.fetch(fetchRequest)
        return objects.compactMap{ object in
            if let obj = object as? T {
                return obj
            } else {
                print("There's error")
                return nil
            }
        }
    }
}
extension NSManagedObject : fetchable {
    
}

extension NSManagedObjectContext {
    func deleteWithSave(_ object: NSManagedObject) {
        self.delete(object)
        try! self.save()
    }
}
