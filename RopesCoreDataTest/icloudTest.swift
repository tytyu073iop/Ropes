//
//  icloudTest.swift
//  Ropes ICloud
//
//  Created by Илья Бирюк on 6.08.23.
//

import CloudKit
import XCTest
@testable import Ropes
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

final class ICloudTest: XCTestCase {
    override func setUpWithError() throws {
        globalSetUP()
    }
    override func tearDownWithError() throws {
        globalTearDown()
    }
    ///check if ICloud storage has Record meeting requirements
    ///- Parameters:
    /// - RecordType: type of record like CD_ToDo
    /// - predicate: the value to find
    /// - key: where to find value
    func compareWithCloud(RecordType : String, predicate : String, key : String = "CD_name", expectation : XCTestExpectation, ic_fail_expect : XCTestExpectation) {
        let query = CKQuery(recordType: RecordType, predicate: NSPredicate(format: "%K == %@", key, predicate))
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = [key]
        operation.recordMatchedBlock = {_, Result in
            switch Result {
            case .success(_):
                expectation.fulfill()
            case .failure(let error):
                print("compareWithCloud \(error.localizedDescription)")
            }
        }
        operation.queryCompletionBlock = { _, error in
            if error != nil {
                print("error \(error)")
                ic_fail_expect.fulfill()
            }
        }
        operation.qualityOfService = .userInteractive
        CKContainer.default().privateCloudDatabase.add(operation)
    }
    func testIcloudRopeAdd() {
        try! ToDo(name: "TestRopeICADD")
        let expectation = XCTestExpectation(description: "fetch data from icloud")
        let failExp = XCTestExpectation(description: "Get accsess to cloud")
        failExp.isInverted = true
        sleep(30)
        compareWithCloud(RecordType: "CD_ToDo", predicate: "TestRopeICADD", expectation: expectation, ic_fail_expect: failExp)
        wait(for: [expectation, failExp], timeout: 30)
    }
    func testIcloudRopeDelete() {
        sleep(10)
        let failExp = XCTestExpectation(description: "Get accsess to cloud")
        failExp.isInverted = true
        let request = ToDo.fetchRequest()
        request.fetchLimit = 1
        var todos = try! viewcontext.fetch(request) as! [ToDo]
        try! viewcontext.deleteWithSave(todos.first!)
        sleep(30)
        let expectation = XCTestExpectation(description: "fetch data from cloud")
        expectation.isInverted = true
        compareWithCloud(RecordType: "CD_ToDo", predicate: "AUTO", expectation: expectation, ic_fail_expect: failExp)
        wait(for: [expectation, failExp], timeout: 30)
    }
    func testIcloudFAAdd() {
        try! FastAnswers(name: "FAICAD")
        let expectation = XCTestExpectation(description: "fetch data from icloud")
        let failExp = XCTestExpectation(description: "Get accsess to cloud")
        failExp.isInverted = true
        sleep(30)
        compareWithCloud(RecordType: "CD_FastAnswers", predicate: "FAICAD", expectation: expectation, ic_fail_expect: failExp)
        wait(for: [expectation, failExp], timeout: 30)
    }
    func testIcloudFADelete() {
        XCTSkip("cannot work on my mac")
        sleep(10)
        let failExp = XCTestExpectation(description: "Get accsess to cloud")
        failExp.isInverted = true
        let request = FastAnswers.fetchRequest()
        request.fetchLimit = 1
        var todos = try! viewcontext.fetch(request) as! [FastAnswers]
        viewcontext.delete(todos.first!)
        try! viewcontext.save()
        sleep(30)
        let expectation = XCTestExpectation(description: "fetch data from cloud")
        expectation.isInverted = true
        compareWithCloud(RecordType: "CD_FastAnswers", predicate: "AUTO", expectation: expectation, ic_fail_expect: failExp)
        wait(for: [expectation, failExp], timeout: 30)
    }
    func testOFBRecovery() {
        DESTROYDATA()
        sleep(30)
        let fa = CKRecord(recordType: "CD_FastAnswers")
        fa.setObject("OFB" as NSString, forKey: "CD_name")
        fa.setObject(UUID().uuidString as NSString, forKey: "CD_id")
        fa.setObject("FastAnswers" as NSString, forKey: "CD_entityName")
        let rope = CKRecord(recordType: "CD_ToDo")
        rope.setObject("OFB" as NSString, forKey: "CD_name")
        rope.setObject(Date() as NSDate, forKey: "CD_date")
        rope.setObject(UUID().uuidString as NSString, forKey: "CD_id")
        rope.setObject("ToDo" as NSString, forKey: "CD_entityName")
        let operation = CKModifyRecordsOperation(recordsToSave: [fa, rope])
        operation.modifyRecordsResultBlock = { result in
            switch result {
            case .success(let _):
                print("succcc")
            case .failure(let error):
                print("CKERROR: \(error.localizedDescription)")
            }
        }
        operation.qualityOfService = .userInteractive
        let container = CKContainer.default()
        let db = container.privateCloudDatabase
        db.add(operation)
        sleep(30)
        let requestFA = FastAnswers.fetchRequest()
        let fas = try! viewcontext.fetch(requestFA) as! [FastAnswers]
        let requestToDo = ToDo.fetchRequest()
        let ToDos = try! viewcontext.fetch(requestToDo) as! [ToDo]
        XCTAssert(fas.first!.name == "OFB", "FastAnswers wasn't fetched")
        XCTAssert(ToDos.first!.name == "OFB", "ToDos wasn't fetched")
    }
}

