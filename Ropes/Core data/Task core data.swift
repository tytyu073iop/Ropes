import SwiftUI
import CoreData

@objc(ToDo)
public class ToDo: NSManagedObject {
    @NSManaged public var id : UUID
    @NSManaged public var name : String
    @NSManaged public var date : Date
}

extension ToDo : Identifiable {
    
    @MainActor func remove() {
        print("start removing")
        let viewcontext = PersistenceController.shared.container.viewContext
        viewcontext.delete(self)
        LocalNotficationManager.remove(id : name)
        PersistenceController.save()
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
    static func findByID (id : String) throws -> ToDo {
        let request = ToDo.fetchRequest()
        guard let Ropes = try PersistenceController.shared.container.viewContext.fetch(request) as? [ToDo] else {
            throw ProgramErrors.Nil
        }
        print("wantable id \(id)  \(Ropes)")
        print("ids")
        if let value = Ropes.first { todo in
            print(todo.id.uuidString)
            return todo.id.uuidString == id
        }{
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
