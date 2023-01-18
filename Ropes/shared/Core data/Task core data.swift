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
    
    func remove(context : NSManagedObjectContext = PersistenceController.shared.container.viewContext, auto : Bool = true, fromConnectivity : Bool = false) {
        NSLog("Start removing")
        let viewcontext = context
        if auto {
            LocalNotficationManager.remove(id : name ?? "error")
            UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [name ?? "error"])
            NSLog("Removed notfication")
        }
        do {
            Task {
                viewcontext.delete(self)
                try viewcontext.save()
            }
            NSLog("Removing rope")
            NSLog("Rope deleted")
        }
        catch {
            print(error.localizedDescription)
        }
        #if os(iOS)
        WidgetCenter.shared.reloadAllTimelines()
        #endif
        print("removing complete")
    }
    @MainActor private func PushNotfication(time : Double) throws {
        try LocalNotficationManager.shared.request(text : name ?? "error", time : time, userInfo: ["id" : id ?? UUID() .uuidString])
    }
    @MainActor private func PushNotfication(time : Date) throws {
        try LocalNotficationManager.shared.request(text: name ?? "error", time: time)
    }
    convenience init(context : NSManagedObjectContext = PersistenceController.shared.container.viewContext, name : String, id : UUID = UUID(), auto : Bool = true, time : Double = defaults.double(forKey: "time"), date_of_creation : Date = Date(), from_message : Bool = false) throws {
        print("begin saving")
        if name == "" {
            throw AddingErrors.EmptyName
        }
        let objects = ToDo.fetch()
        if objects.contains(where: { toDo in
            return toDo.name == name
        }) {
            throw AddingErrors.ThisNameIsExciting
        }
        if auto {
            try LocalNotficationManager.shared.request(text : name, time : time, userInfo: ["id" : id.uuidString])
        }
        self.init(context : context)
        self.name = name
        self.date = date_of_creation
        self.id = id
        PersistenceController.save()
        WidgetCenter.shared.reloadAllTimelines()
    }
    static func findByID (id : String, context : NSManagedObjectContext = PersistenceController.shared.container.viewContext) throws -> ToDo {
        let request = ToDo.fetchRequest()
        guard let ropes = try context.fetch(request) as? [ToDo] else {
            throw ProgramErrors.Nil
        }
        print("wantable id \(id)  \(ropes)")
        print("ids")
        NSLog("ids")
        if let value = (ropes.filter { todo in
            print(todo.id!.uuidString)
            NSLog(todo.id!.uuidString)
            return todo.id!.uuidString == id
        }.first) {
            print("found")
            NSLog("found")
            NSLog(value.name ?? "error")
            return value
        }else {
            print("ids")
            throw ProgramErrors.Nil
            
        }
    }
}

@objc(FastAnswers)
public class FastAnswers: NSManagedObject {
    @NSManaged public var id : UUID?
    @NSManaged public var name : String?
}

extension FastAnswers: Identifiable {
    func remove(fromConnectivity : Bool = false) {
        let viewContext = PersistenceController.shared.container.viewContext
        Task {
            if !fromConnectivity {
#if os(iOS) || os(watchOS)
                //await WC.shared.send(["IDForRemoveFA" : self.id!.uuidString])
                #endif
            }
            viewContext.delete(self)
            PersistenceController.save()
        }
    }
    static func findById(id : String, context : NSManagedObjectContext = PersistenceController.shared.container.viewContext) throws -> FastAnswers? {
        let request = FastAnswers.fetchRequest()
        guard let fastAnswers = try context.fetch(request) as? [FastAnswers] else {
            throw ProgramErrors.Nil
        }
        return fastAnswers.first { fastAnswer in
            fastAnswer.id == UUID(uuidString: id)
        }
    }
    convenience init(context : NSManagedObjectContext = PersistenceController.shared.container.viewContext, id : UUID = UUID(), name : String, fromConnectivity : Bool = false) throws {
        let objects = FastAnswers.fetch()
        if objects.contains(where: {
            return $0.name == name
        }) {
            throw AddingErrors.ThisNameIsExciting
        }
        self.init(context : context)
        self.id = id
        self.name = name
        PersistenceController.save()
        if !fromConnectivity {
            Task {
#if os(iOS) || os(watchOS)
                //await WC.shared.send(["FastAnswersID" : id.uuidString, "FastAnswersName" : name])
                #endif
                print("sended")
            }
        }
    }
}
