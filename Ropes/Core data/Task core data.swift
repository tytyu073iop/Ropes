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
        viewcontext.delete(self)
        LocalNotficationManager.remove(id : name)
        do {
            try context.save()
        }
        catch {
            print(error.localizedDescription)
        }
        print("removing complete")
    }
    @MainActor private func PushNotfication(time : Double) {
        LocalNotficationManager.shared.request(text : name, time : time, id : id, userInfo: ["id" : id.uuidString])
    }
    @MainActor private func PushNotfication(time : Date) throws {
        try LocalNotficationManager.shared.request(text: name, time: time)
    }
    @MainActor convenience init(context : NSManagedObjectContext, name : String, id : UUID = UUID(), auto : Bool = true) {
        self.init(context : context)
        self.name = name
        self.date = Date.now
        self.id = id
        PersistenceController.save()
        WC.shared.send("Tasks", [self])
        if auto {
            PushNotfication(time: defaults.double(forKey: "time"))
        }
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
