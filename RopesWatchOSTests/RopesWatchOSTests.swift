//
//  RopesWatchOSTests.swift
//  RopesWatchOSTests
//
//  Created by Илья Бирюк on 4.11.22.
//

import XCTest
@testable import Ropes

final class RopesWatchOSTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        let testSubjects = ["1111", "aaaaa", "😀"]
        let viewContext = PersistenceController.shared.container.viewContext
        for subject in testSubjects {
            do {
                _ = try ToDo(context: viewContext,name: subject)
                _ = try FastAnswers(name: subject)
            } catch AddingErrors.ThisNameIsExciting {
                
            }
        }
        ToDo.fetch().last!.remove()
        print(PopUp().PopUp)
        PopUp().PopUp = false
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
