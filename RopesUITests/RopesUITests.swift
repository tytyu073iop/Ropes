//
//  RopesUITests.swift
//  RopesUITests
//
//  Created by Илья Бирюк on 4.11.22.
//

import XCTest
import Foundation
@testable import Ropes

final class RopesUITests: XCTestCase {

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

    func testFastAnswersAndAdding() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        XCUIApplication().navigationBars["Ropes"].buttons["Settings"].tap()
        
        let collectionViewsQuery = app.collectionViews
        
        let collectionViewsQuery2 = app.collectionViews
        let textField = collectionViewsQuery2.textFields["Enter something"]
        textField.tap()
        textField.typeText("Delete2")
        app.buttons["Return"].tap()
        textField.tap()
        textField.typeText("Delete")
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
                

        collectionViewsQuery2.staticTexts["Delete2"].swipeLeft()
        
        let button = collectionViewsQuery2.buttons["Delete"]
        button.tap()
        
        let navigationBar = app.navigationBars["settings"]
        navigationBar.buttons["Edit"].tap()
        
        let cell = collectionViewsQuery2.children(matching: .cell).element(boundBy: 2)
        XCUIApplication().collectionViews.cells.otherElements.containing(.image, identifier:"remove").element.tap()
        button.tap()
        navigationBar.children(matching: .other).matching(identifier: "ready").element(boundBy: 0).buttons["ready"].tap()
        
        let button2 = app.toolbars["Toolbar"].buttons["ADD"]
        button2.tap()
        let textField2 = collectionViewsQuery2.textFields["Your rope"]
        textField2.tap()
        textField2.typeText("test")
        
        let switch3 = collectionViewsQuery2.switches["add to fast Answers"]
        switch3.tap()
        switch3.tap()
        switch3.tap()
        textField2.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".keyboards",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        XCUIApplication().collectionViews/*@START_MENU_TOKEN@*/.buttons["Trash"]/*[[".cells.buttons[\"Trash\"]",".buttons[\"Trash\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()

        button2.tap()
        collectionViewsQuery2/*@START_MENU_TOKEN@*/.buttons["test"]/*[[".cells.buttons[\"test\"]",".buttons[\"test\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
                
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testTimeScroll() throws {
        let app = XCUIApplication()
        app.launch()

        XCUIApplication().navigationBars["Ropes"].buttons["Settings"].tap()
        
        
        let collectionViewsQuery = app.collectionViews
        
        do {
            try collectionViewsQuery.pickerWheels["10 minutes"].swipeUp()
        } catch {
            collectionViewsQuery.pickerWheels["5 minutes"].swipeUp()
        }
        collectionViewsQuery.pickerWheels["30 minutes"].swipeDown()
    }
    
    func testShowUPAddingView() throws {
        let app = XCUIApplication()
        app.launch()

        XCUIApplication().navigationBars["Ropes"].buttons["Settings"].tap()
        let collectionViewsQuery = app.collectionViews
        
        XCUIApplication().collectionViews/*@START_MENU_TOKEN@*/.staticTexts["TIME"]/*[[".cells.staticTexts[\"TIME\"]",".staticTexts[\"TIME\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        
        
        let switch2 = collectionViewsQuery.switches["Showup an adding view on start"]
        switch2.tap()
        
        XCUIDevice().press(XCUIDevice.Button.home)
        
        app.launch()
        XCUIApplication().collectionViews/*@START_MENU_TOKEN@*/.textFields["Your rope"]/*[[".cells.textFields[\"Your rope\"]",".textFields[\"Your rope\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
