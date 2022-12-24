//
//  WatchUITest.swift
//  WatchUITest
//
//  Created by Илья Бирюк on 6.11.22.
//

import XCTest
@testable import Ropes

final class WatchUITest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddingToDos() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        app.buttons["DELETE ALL DATA"].tap()
        app.buttons.firstMatch.tap()
        let textfield = app.textFields.firstMatch
        textfield.tap()
        app.keyboards.firstMatch.tap()
        app.buttons["Done"].tap()
        app.buttons["Trash"].tap()
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
