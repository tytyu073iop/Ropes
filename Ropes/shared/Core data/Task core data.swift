import SwiftUI
import CoreData
import WidgetKit
import UserNotifications

@objc(ToDo)
public class ToDo: NSManagedObject {
    @NSManaged public var id : UUID?
    @NSManaged public var name : String?
    @NSManaged public var date : Date?
}

extension ToDo : Identifiable {
    ///Activates when object is removed
    override public func prepareForDeletion() {
        NSLog("Start removing")
        LocalNotficationManager.remove(id : name ?? "error")
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [name ?? "error"])
        NSLog("Removed notfication")
        WidgetCenter.shared.reloadAllTimelines()
    }
    override public func willSave() {
        if self.isInserted {
            LocalNotficationManager.shared.request(text : name ?? "error", time : defaults.double(forKey: "time"),id: id?.uuidString ?? "UUID()")
        }
        WidgetCenter.shared.reloadAllTimelines()
    }
    ///Activates when object is added
    override public func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(Date(), forKey: "date")
        setPrimitiveValue("This item isn't have a name yet", forKey: "name")
        setPrimitiveValue(UUID(), forKey: "id")
    }
    convenience init(context : NSManagedObjectContext = PersistenceController.shared.container.viewContext, name : String) throws {
        if name == "" {
            throw AddingErrors.EmptyName
        }
        self.init(context : context)
        self.name = name
        LocalNotficationManager.shared.request(text : name, time : defaults.double(forKey: "time"),id: id?.uuidString ?? "")
        WidgetCenter.shared.reloadAllTimelines()
        try! context.save()
    }
}

@objc(FastAnswers)
public class FastAnswers: NSManagedObject {
    @NSManaged public var id : UUID?
    @NSManaged public var name : String?
}

extension FastAnswers: Identifiable {
    static func findById(id : String, context : NSManagedObjectContext = PersistenceController.shared.container.viewContext) throws -> FastAnswers? {
        let request = FastAnswers.fetchRequest()
        guard let fastAnswers = try context.fetch(request) as? [FastAnswers] else {
            throw ProgramErrors.Nil
        }
        return fastAnswers.first { fastAnswer in
            fastAnswer.id == UUID(uuidString: id)
        }
    }
    convenience init(context : NSManagedObjectContext = PersistenceController.shared.container.viewContext, id : UUID = UUID(), name : String) throws {
        self.init(context : context)
        self.id = id
        self.name = name
        try! context.save()
    }
}
