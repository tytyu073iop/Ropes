//
//  RopesCoreDataTest.swift
//  RopesCoreDataTest
//
//  Created by Илья Бирюк on 4.11.22.
//

import XCTest
#if os(iOS)
@testable import Ropes
#else
@testable import Ropes
#endif
import CloudKit
import CoreData
import UserNotifications

let viewcontext = PersistenceController.shared.container.viewContext
func DESTROYDATA() {
    let todos = try! viewcontext.fetch(ToDo.fetchRequest()) as! [ToDo]
    for todo in todos {
        viewcontext.delete(todo)
    }
    var fas = try! viewcontext.fetch(FastAnswers.fetchRequest()) as! [FastAnswers]
    for todo in fas {
        viewcontext.delete(todo)
    }
}
//#error("Divide into classes")
 func globalSetUP() {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    DESTROYDATA()
    try! ToDo(name: "AUTO")
    try! FastAnswers(name: "AUTO")
}
 func globalTearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    DESTROYDATA()
}
final class RopesCoreDataTest: XCTestCase {
    
    override func setUpWithError() throws {
        globalSetUP()
    }
    override func tearDownWithError() throws {
        globalTearDown()
    }
    
    func testRopeADD() {
        try! ToDo(name: "TestRopeADD")
        let request = ToDo.fetchRequest()
        request.predicate = NSPredicate(format: "name == \"TestRopeADD\"")
        var todos = try! viewcontext.fetch(request) as! [ToDo]
        XCTAssert(todos.count == 1,"Changes wasn't saved")
    }
    func testFAADD() {
        try! FastAnswers(name: "TestFAADD")
        let request = FastAnswers.fetchRequest()
        request.predicate = NSPredicate(format: "name == \"TestFAADD\"")
        var todos = try! viewcontext.fetch(request) as! [FastAnswers]
        XCTAssert(todos.count == 1,"Changes wasn't saved")
    }
    func testRopeDelete() {
        let request = ToDo.fetchRequest()
        request.fetchLimit = 1
        var todos = try! viewcontext.fetch(request) as! [ToDo]
        try! viewcontext.deleteWithSave(todos.first!)
        XCTAssert(try! viewcontext.fetch(ToDo.fetchRequest()).count == 0, "Changes wasn't saved")
    }
    func testFADelete() {
        let request = FastAnswers.fetchRequest()
        request.fetchLimit = 1
        var todos = try! viewcontext.fetch(request) as! [FastAnswers]
        try! viewcontext.deleteWithSave(todos.first!)
        XCTAssert(try! viewcontext.fetch(FastAnswers.fetchRequest()).count == 0, "Changes wasn't saved")
    }
}
final class NotficationsTest: XCTestCase {
    override func setUpWithError() throws {
        globalSetUP()
    }
    override func tearDownWithError() throws {
        globalTearDown()
    }
    func testNotficationsAdd() async {
        try! ToDo(name: "TestNFAADD")
        var not : Bool = false
        var notfications = await UNUserNotificationCenter.current().pendingNotificationRequests()
        not = notfications.contains { $0.content.title == "TestNFAADD"}
        XCTAssert(not, "Notfication wasn't created")
    }
    func testNotficationsDelete() async {
        let request = ToDo.fetchRequest()
        request.fetchLimit = 1
        var todos = try! viewcontext.fetch(request) as! [ToDo]
        try! viewcontext.deleteWithSave(todos.first!)
        var notfications = await UNUserNotificationCenter.current().pendingNotificationRequests()
        XCTAssert(notfications.count == 0, "Notfication wasn't deleted")
    }
    func testNotficationsDelay() async {
        Time().time = 30
        var notfications = await UNUserNotificationCenter.current().pendingNotificationRequests()
        XCTAssert((notfications.first!.trigger as! UNTimeIntervalNotificationTrigger).timeInterval == 30, "Notfication wasn't delayed")
    }
}
