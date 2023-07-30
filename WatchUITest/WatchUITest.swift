//
//  WatchUITest.swift
//  WatchUITest
//
//  Created by Илья Бирюк on 6.11.22.
//

import XCTest
@testable import Ropes

final class WatchInterfaceUITest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    let app = XCUIApplication()
    func testAddRopeFA() throws {
        app.launchArguments = [launchArgs.requiresFA.rawValue,launchArgs.clear.rawValue]
        app.launch()
        app.buttons["Add"].tap()
        app.buttons["Test"].tap()
        XCTAssert(app.staticTexts["Test"].waitForExistence(timeout: 1),"action haven't created a rope")
    }
    func testAddRopeKeyboard() throws {
        app.launchArguments = [launchArgs.clear.rawValue]
        app.launch()
        app.buttons["Add"].tap()
        app.textFields.firstMatch.tap()
        print(app.debugDescription)
        app.buttons["SPACE"].tap()
        app.buttons["Done"].tap()
        XCTAssert(app.staticTexts[" "].waitForExistence(timeout: 1),"Action haven't created a rope")
    }
    func testRemoveRope() {
        app.launchArguments = [launchArgs.reqiresR.rawValue,launchArgs.clear.rawValue]
        app.launch()
        let predicate = NSPredicate(format: "label == \"Bin\" OR label == \"Trash\"")
        app.buttons.matching(predicate).firstMatch.tap()
        XCTAssert(!app.staticTexts["Test"].exists,"Hasn't deleted")
    }
}

final class WatchNotifyUITest: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    let app = XCUIApplication()
    let springboard = XCUIApplication(bundleIdentifier: "com.apple.Carousel")
    func testNotficationAppear() {
        app.launchArguments = [launchArgs.reqiresR.rawValue]
        app.launch()
        XCTAssert(springboard.otherElements["Test, Ropes"].waitForExistence(timeout: 10))
    }
    func testNotficationClick() {
        app.launchArguments = [launchArgs.reqiresR.rawValue,launchArgs.clear.rawValue]
        app.launch()
        springboard.otherElements["Test, Ropes"].waitForExistence(timeout: 10)
        springboard.otherElements["Test, Ropes"].tap()
        springboard.staticTexts["Done"].tap()
        XCTAssert(!app.staticTexts["Test"].exists,"Action fallen")
    }
    let shortcuts = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
    func testNotficationTesrminatedClick() {
        app.launchArguments = [launchArgs.reqiresR.rawValue,launchArgs.clear.rawValue]
        app.launch()
        app.terminate()
        springboard.otherElements["Test, Ropes"].waitForExistence(timeout: 10)
        if springboard.otherElements["Test, Ropes"].exists {
            springboard.otherElements["Test, Ropes"].tap()
        }
        springboard.staticTexts["Done"].tap()
        app.launchArguments = []
        app.launch()
        XCTAssert(!app.staticTexts["Test"].exists,"Action fallen")
    }
}

enum launchArgs: String {
    case reqiresR = "ReqiresR"
    case requiresFA = "RequiresFA"
    case clear = "clean"
}
