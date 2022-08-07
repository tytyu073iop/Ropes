import SwiftUI
import CoreData

@objc(ToDo)
public class ToDo: NSManagedObject {
    @NSManaged public var id : UUID
    @NSManaged public var name : String
    @NSManaged public var date : Date
}

extension ToDo : Identifiable {
    func remove() {
        let viewcontext = PersistenceController.shared.container.viewContext
        viewcontext.delete(self)
        LocalNotficationManager.remove(id : name)
        PersistenceController.save()
    }
    private func PushNotfication(time : Double) {
        LocalNotficationManager.shared.request(text : name, time : time, id : id)
    }
    private func PushNotfication(time : Date) throws {
        try LocalNotficationManager.shared.request(text: name, time: time)
    }
    convenience init(context : NSManagedObjectContext, name : String, id : UUID = UUID(), auto : Bool = true) {
        self.init(context : context)
        self.name = name
        self.date = Date.now
        self.id = id
        PersistenceController.save()
        if auto {
            PushNotfication(time: defaults.double(forKey: "time"))
        }
    }
    convenience init(context : NSManagedObjectContext, name : String, id : UUID = UUID(), time : Date) throws {
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
