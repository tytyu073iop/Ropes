import SwiftUI
import CoreData

@objc(ToDo)
public class ToDo: NSManagedObject {
    @NSManaged public var id : UUID
    @NSManaged public var name : String
    @NSManaged public var date : Date
}

extension ToDo : Identifiable {
    
    @MainActor func remove(context : NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        print("start removing")
        let viewcontext = context
        LocalNotficationManager.remove(id : name)
        viewcontext.delete(self)
        do {
            try viewcontext.save()
            print(context)
            print(viewcontext)
        }
        catch {
            print(error.localizedDescription)
        }
        print("removing complete")
    }
    @MainActor private func PushNotfication(time : Double) throws {
        try LocalNotficationManager.shared.request(text : name, time : time, id : id, userInfo: ["id" : id.uuidString])
    }
    @MainActor private func PushNotfication(time : Date) throws {
        try LocalNotficationManager.shared.request(text: name, time: time)
    }
    @MainActor convenience init(context : NSManagedObjectContext, name : String, id : UUID = UUID(), auto : Bool = true, time : Double = defaults.double(forKey: "time")) throws {
        print("begin saving")
        // Create a fetch request for a specific Entity type
        let fetchRequest = ToDo.fetchRequest()

        // Get a reference to a NSManagedObjectContext
        let context = PersistenceController.shared.container.viewContext

        // Fetch all objects of one Entity type
        let objects = try context.fetch(fetchRequest)
        if objects.contains(where: {
            if let toDo = $0 as? ToDo {
                return toDo.name == name
            } else {
                return false
            }
        }) {
            throw AddingErrors.ThisNameIsExciting
        }
        if auto {
            try LocalNotficationManager.shared.request(text : name, time : time, id : id, userInfo: ["id" : id.uuidString])
        }
        self.init(context : context)
        self.name = name
        self.date = Date.now
        self.id = id
        print("ready")
        PersistenceController.save()
        print("saved")
        #if os(iOS) || os(watchOS)
            WC.shared.send("Tasks", [self])
        #endif
    }
    @MainActor convenience init(context : NSManagedObjectContext, name : String, id : UUID = UUID(), time : Date) throws {
        self.init(context : context)
        self.name = name
        self.date = time
        self.id = id
        PersistenceController.save()
        do {
            try PushNotfication(time: time)
        } catch {
            self.remove()
            throw error
        }
        print("aboba")
    }
    static func findByID (id : String, context : NSManagedObjectContext = PersistenceController.shared.container.viewContext) throws -> ToDo {
        let request = ToDo.fetchRequest()
        guard let ropes = try context.fetch(request) as? [ToDo] else {
            throw ProgramErrors.Nil
        }
        print("wantable id \(id)  \(ropes)")
        print("ids")
        if let value = (ropes.first { todo in
            print(todo.id.uuidString)
            return todo.id.uuidString == id
        }) {
            print("found")
            return value
        }else {
            print("ids")
            throw ProgramErrors.Nil
            
        }
    }
}

@objc(FastAnswers)
public class FastAnswers: NSManagedObject {
    @NSManaged public var id : UUID
    @NSManaged public var name : String
}

extension FastAnswers: Identifiable {
    func remove() {
        let viewContext = PersistenceController.shared.container.viewContext
        viewContext.delete(self)
        PersistenceController.save()
    }
    convenience init(context : NSManagedObjectContext, id : UUID = UUID(), name : String) {
        self.init(context : context)
        self.id = id
        self.name = name
        PersistenceController.save()
    }
}
