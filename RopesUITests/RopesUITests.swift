//
//  RopesUITests.swift
//  RopesUITests
//
//  Created by Илья Бирюк on 4.11.22.
//

import XCTest
import Foundation
@testable import Ropes

func randomString(length: Int) -> String {
  let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
  return String((0..<length).map{ _ in letters.randomElement()! })
}

func emptyPredictArray() -> [XCTestExpectation] {
    let text = randomString(length: 20)
    return [XCTestExpectation(description: text)]
}

final class RopesInterfaceUITests: XCTestCase {
    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        addUIInterruptionMonitor(withDescription: "Notfication Alert") { element in
            let allowButton = element.buttons["allow"].firstMatch
            if element.elementType == .alert && allowButton.exists {
                allowButton.tap()
                return true
            } else {
                return false
            }
        }
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {

    }
    let app = XCUIApplication()
    

    func testFastAnswersAdd() throws {
        // UI tests must launch the application that they test.
        app.launch()
        app.buttons["DELETE ALL DATA"].tap()
        app/*@START_MENU_TOKEN@*/.buttons["Settings"]/*[[".otherElements[\"Settings\"].buttons[\"Settings\"]",".buttons[\"Settings\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.textFields.firstMatch.tap()
        app.typeText("Test\n")
        XCTAssert(app.staticTexts["Test"].exists,"No Test field after adding")
    }
    
    func testFastAnswersUse() throws {
        app.launchArguments = ["clean", "RequiresFA"]
        app.launch()
        app.buttons["ADD"].tap()
        XCTAssert(app.buttons["Test"].exists,"No test button")
    }
    
    func testADDkeyboard() throws {
        app.launch()
        app.buttons["ADD"].tap()
        app.textFields.firstMatch.tap()
        app.typeText("ADDkeyboard\n")
        XCTAssert(app.staticTexts["ADDkeyboard"].exists,"No rope after adding")
    }
    
    func testADDFastAnswers() throws {
        app.launchArguments = [launchArgs.clear.rawValue,launchArgs.requiresFA.rawValue]
        app.launch()
        app.buttons["ADD"].tap()
        app.buttons["Test"].tap()
        XCTAssert(app.staticTexts["Test"].exists,"No rope after fast answer")
    }
    
    func testRemoveFastAnswers() throws {
        app.launchArguments = [launchArgs.clear.rawValue,launchArgs.requiresFA.rawValue]
        app.launch()
        app.buttons["Settings"].tap()
        app.staticTexts["Test"].swipeLeft()
        app.buttons["Delete"].tap()
        XCTAssert(!app.staticTexts["Test"].exists,"didn't deleted")
        app.terminate()
        app.launchArguments = []
        app.launch()
        app.buttons["ADD"].tap()
        XCTAssert(!app.buttons["Test"].exists,"didn't deleted on add sheet")
    }
    
    func testRemoveRopes() throws {
        app.launchArguments = [launchArgs.clear.rawValue,launchArgs.reqiresR.rawValue]
        app.launch()
        let predicate = NSPredicate(format: "label == \"Bin\" OR label == \"Trash\"")
        app.buttons.matching(predicate).firstMatch.tap()
        XCTAssert(!app.buttons.matching(predicate).firstMatch.exists,"Item wasn't removed by a trash button")
    }
}

    final class RopesNoficationsUITests: XCTestCase {
        override func setUpWithError() throws {
            // Put setup code here. This method is called before the invocation of each test method in the class.

            // In UI tests it is usually best to stop immediately when a failure occurs.
            continueAfterFailure = false
            
            addUIInterruptionMonitor(withDescription: "Notfication Alert") { element in
                let allowButton = element.buttons["allow"].firstMatch
                if element.elementType == .alert && allowButton.exists {
                    allowButton.tap()
                    return true
                } else {
                    return false
                }
            }
            // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        }

        override func tearDownWithError() throws {

        }
        let app = XCUIApplication()
        let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
        let shortcuts = XCUIApplication(bundleIdentifier: "com.apple.shortcuts")
        fileprivate func typer(_ app: XCUIApplication, type: String) {
            app.buttons["ADD"].tap()
            app.textFields.firstMatch.tap()
            app.typeText("\(type)\n")
        }
        
        let Notfication: XCUIElement = XCUIApplication(bundleIdentifier: "com.apple.springboard").otherElements["Notfication"]
        
        func testNotficationAppear() throws {
            app.launch()
            let text = "NotficationAppear"
            typer(app, type: text)
            XCTAssert(springboard.otherElements["Notification"].waitForExistence(timeout: 15),"Notfication didn't appeared in 15 seconds")
        }
        
        func testNotficationOpen() throws {
            app.launchArguments = [launchArgs.clear.rawValue]
            app.launch()
            let text = "NotficationOpen"
            typer(app, type: text)
            XCTWaiter.wait(for: [XCTestExpectation(description: "")], timeout: 10)
            springboard.otherElements["Notification"].tap()
        }
        
        func testNotficationWhenClose() throws {
            app.launchArguments = [launchArgs.clear.rawValue]
            app.launch()
            typer(app, type: "NotficationWhenClose")
            shortcuts.launch()
            springboard.otherElements["Notification"].waitForExistence(timeout: 10)
            springboard.otherElements["Notification"].tap()
            
        }
        
        func testNotficationWhenTerminated() throws {
            app.launch()
            typer(app, type: "NotficationWhenTerminated")
            app.terminate()
            springboard.otherElements["Notification"].waitForExistence(timeout: 10)
            springboard.otherElements["Notification"].tap()
            
        }
        
        func testNotficationAcitonWhenClosed() throws {
            try XCTSkipIf(!(UIDevice.current.userInterfaceIdiom == .phone))
            app.launch()
            typer(app, type: "NotficationActionWhenClose")
            shortcuts.launch()
            springboard.otherElements["Notification"].waitForExistence(timeout: 10)
            springboard.otherElements["Notification"].press(forDuration: 3)
            springboard.buttons["Done"].tap()
            app.activate()
            XCTAssert(!app.staticTexts["NotficationActionWhenClose"].exists,"Action wasn't fired")
        }
        
        func testActionNotficationWhenOpened() throws {
            try XCTSkipIf(!(UIDevice.current.userInterfaceIdiom == .phone))
            app.launch()
            typer(app, type: "NotficationAction")
            springboard.otherElements["Notification"].waitForExistence(timeout: 10)
            springboard.otherElements["Notification"].press(forDuration: 3)
            springboard.buttons["Done"].tap()
            XCTAssert(!app.staticTexts["NotficationActionWhenClose"].exists,"Action wasn't fired")
        }
        
        func testNotficationActionWhenTerminated() throws {
            try XCTSkipIf(!(UIDevice.current.userInterfaceIdiom == .phone))
            app.launchArguments = [launchArgs.clear.rawValue]
            app.launch()
            typer(app, type: "NotficationActionWhenTerminated")
            app.terminate()
            XCTWaiter.wait(for: [XCTestExpectation(description: "")], timeout: 10)
            springboard.otherElements["Notification"].press(forDuration: 3)
            springboard.buttons["Done"].tap()
            app.launchArguments = []
            XCTWaiter.wait(for: emptyPredictArray(), timeout: 3)
            app.launch()
            XCTAssert(!app.staticTexts["NotficationActionWhenTerminated"].exists,"Action wasn't fired")
        }
        func testShowAdd() throws {
            XCTFail("create a test")
        }
    }

final class RopesShortcutsUITests: XCTestCase {
    override func setUpWithError() throws {
        app.launch()
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        addUIInterruptionMonitor(withDescription: "Notfication Alert") { element in
            let allowButton = element.buttons["allow"].firstMatch
            if element.elementType == .alert && allowButton.exists {
                allowButton.tap()
                return true
            } else {
                return false
            }
        }
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {

    }
    let app = XCUIApplication()
    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    let shortcuts = XCUIApplication(bundleIdentifier: "com.apple.shortcuts")
    func testShortcutAdd() throws {
        try XCTSkipIf(!(UIDevice.current.userInterfaceIdiom == .phone))
        shortcuts.launch()
        findShortcut("Create a Ropes")
        print(shortcuts.debugDescription)
        print(springboard.debugDescription)
        springboard.textFields.firstMatch.tap()
        springboard.typeText("ShortcutAdd")
        springboard.buttons["Done"].tap()
        springboard.buttons["Done"].tap()
        XCTAssert(springboard.otherElements["Notification"].waitForExistence(timeout: 15),"Notfication didn't appeared in 15 seconds")
    }
    
    fileprivate func findShortcut(_ name: String) {
        let button = shortcuts.buttons[name]
        print(shortcuts.debugDescription)
        let predicate = NSPredicate(format: "identifier == \"all_shortcuts_library\"")
        while !button.exists {
            shortcuts.otherElements.matching(predicate).firstMatch.swipeUp(velocity: XCUIGestureVelocity(5000))
        }
        button.tap()
    }
    
    func testShortcutShow() throws {
        try XCTSkipIf(!(UIDevice.current.userInterfaceIdiom == .phone))
        shortcuts.launch()
        findShortcut("Show Ropes")
        XCTWaiter.wait(for: [XCTestExpectation(description: "")], timeout: 3)
        springboard.buttons["Done"].tap()
    }
    
    fileprivate func PrepareAction(_ name: String) {
        shortcuts.launch()
        let predicate = NSPredicate(format: "label == \"add\" OR label == \"Create Shortcut\"")
        shortcuts.buttons.matching(predicate).firstMatch.tap()
        shortcuts.searchFields.firstMatch.tap()
        shortcuts.typeText("Ropes")
        shortcuts.buttons["Ropes"].tap()
        shortcuts.buttons[name].firstMatch.tap()
        XCTWaiter.wait(for: emptyPredictArray(), timeout: 3)
    }
    
    func testShortcutAddAction() throws {
        try XCTSkipIf(!(UIDevice.current.userInterfaceIdiom == .phone))
        PrepareAction("Add rope")
        shortcuts.otherElements["Create a rope , Task"].firstMatch.tap()
        shortcuts.buttons["Current Date"].tap()
        shortcuts.buttons["Return"].tap()
        let button = shortcuts.keyboards.firstMatch.buttons["done"]
        if button.exists {
            button.tap()
        }
        shortcuts.buttons["Run Shortcut"].tap()
        springboard.buttons["Done"].tap()
        app.launch()
        XCTAssert(app.staticTexts.firstMatch.exists,"The rope haven't appeared")
    }
    
    func testShortcutShowAction() throws {
        try XCTSkipIf(!(UIDevice.current.userInterfaceIdiom == .phone))
        PrepareAction("Show Ropes")
        shortcuts.buttons["Run Shortcut"].tap()
        springboard.buttons["Done"].tap()
    }
    
    func testShortcutRemoveAction() throws {
        try XCTSkipIf(!(UIDevice.current.userInterfaceIdiom == .phone))
        app.launchArguments = ["ReqiresR","clean"]
        app.launch()
        PrepareAction("Remove rope")
        shortcuts.otherElements["Remove a rope , Rope"].tap()
        XCTWaiter.wait(for: [XCTestExpectation(description: "empyu")], timeout: 2)
        shortcuts.staticTexts["Test"].firstMatch.tap()
        shortcuts.buttons["Run Shortcut"].tap()
        app.activate()
        XCTWaiter.wait(for: [XCTestExpectation(description: "empy")], timeout: 2)
        XCTAssert(!app.staticTexts["Test"].exists,"didn't deleted")
    }
}

enum launchArgs: String {
    case reqiresR = "ReqiresR"
    case requiresFA = "RequiresFA"
    case clear = "clean"
}

//final class RopesWidgetsUITests: XCTestCase {
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//
//        // In UI tests it is usually best to stop immediately when a failure occurs.
//        continueAfterFailure = false
//
//        addUIInterruptionMonitor(withDescription: "Notfication Alert") { element in
//            let allowButton = element.buttons["allow"].firstMatch
//            if element.elementType == .alert && allowButton.exists {
//                allowButton.tap()
//                return true
//            } else {
//                return false
//            }
//        }
//        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
//    }
//
//    override func tearDownWithError() throws {
//
//    }
//    let app = XCUIApplication()
//    let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
//    let shortcuts = XCUIApplication(bundleIdentifier: "com.apple.shortcuts")
//    func testWidjet() {
//        app.launchArguments = [launchArgs.reqiresR.rawValue, launchArgs.clear.rawValue]
//        app.launch()
//        springboard.activate()
//        XCUIDevice.shared.press(.home)
//        // Swipe Right to go to Widgets view
//        let window = springboard.children (matching: .window).element(boundBy: 0)
//        window.swipeRight ()
//        window.swipeRight ()
//        // Swipe Up to get to the Edit and Add Widget buttons
//        let element = springboard.scrollViews ["left-of-home-scroll-view"].children (matching: .other).element.children (matching: .other) .element (boundBy: 0)
//        element.swipeUp ()
//        element.swipeUp ()
//        element.swipeUp ()
//        springboard.scrollViews["left-of-home-scroll-view"].otherElements.buttons["Edit"].tap()
//        springboard.buttons["Add Widget"].tap()
//        springboard.collectionViews.cells ["Fennec (isabelrios)"].children (matching: .other).element.children (matching: .other).element (boundBy: 0).children(matching: .other).element.tap()
//        springboard.staticTexts[" Add Widget"].tap()
//    }
//}
