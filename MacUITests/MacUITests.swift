//
//  MacUITests.swift
//  MacUITests
//
//  Created by Илья Бирюк on 6.11.22.
//

import XCTest
@testable import Ropes

final class MacUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFastAnswers() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        XCUIApplication()/*@START_MENU_TOKEN@*/.windows["SwiftUI.ModifiedContent<Ropes.ContentView, SwiftUI._EnvironmentKeyWritingModifier<__C.NSManagedObjectContext>>-1-AppWindow-1"].tables.buttons["DELETE ALL DATA"]/*[[".windows[\"Ropes\"]",".groups",".scrollViews.tables",".tableRows",".cells.buttons[\"DELETE ALL DATA\"]",".buttons[\"DELETE ALL DATA\"]",".tables",".windows[\"SwiftUI.ModifiedContent<Ropes.ContentView, SwiftUI._EnvironmentKeyWritingModifier<__C.NSManagedObjectContext>>-1-AppWindow-1\"]"],[[[-1,7,1],[-1,0,1]],[[-1,6,3],[-1,2,3],[-1,1,2]],[[-1,6,3],[-1,2,3]],[[-1,5],[-1,4],[-1,3,4]],[[-1,5],[-1,4]]],[0,0,0]]@END_MENU_TOKEN@*/.click()
        
        
        let menuBarsQuery = XCUIApplication().menuBars
        menuBarsQuery.menuBarItems["Ropes"].click()
        menuBarsQuery/*@START_MENU_TOKEN@*/.menuItems["showSettingsWindow:"]/*[[".menuBarItems[\"Ropes\"]",".menus",".menuItems[\"Settings…\"]",".menuItems[\"showSettingsWindow:\"]"],[[[-1,3],[-1,2],[-1,1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.click()
        
        let comAppleSwiftuiSettingsWindowWindow = app/*@START_MENU_TOKEN@*/.windows["com_apple_SwiftUI_Settings_window"]/*[[".windows[\"settings\"]",".windows[\"com_apple_SwiftUI_Settings_window\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        let enterSomethingTextField = comAppleSwiftuiSettingsWindowWindow/*@START_MENU_TOKEN@*/.tables.textFields["Enter something"]/*[[".groups",".scrollViews.tables",".tableRows",".cells.textFields[\"Enter something\"]",".textFields[\"Enter something\"]",".tables"],[[[-1,5,2],[-1,1,2],[-1,0,1]],[[-1,5,2],[-1,1,2]],[[-1,4],[-1,3],[-1,2,3]],[[-1,4],[-1,3]]],[0,0]]@END_MENU_TOKEN@*/
        enterSomethingTextField.click()
        
        let cell = comAppleSwiftuiSettingsWindowWindow/*@START_MENU_TOKEN@*/.tables/*[[".groups",".scrollViews.tables",".tables"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.children(matching: .tableRow).element(boundBy: 0).children(matching: .cell).element
        cell.typeText("Delete\r")
        comAppleSwiftuiSettingsWindowWindow.tables.buttons["Trash"].click()
        enterSomethingTextField.click()
        cell.typeText("Test\r")
        comAppleSwiftuiSettingsWindowWindow.buttons[XCUIIdentifierCloseWindow].click()
        
        let swiftuiModifiedcontentRopesContentviewSwiftuiEnvironmentkeywritingmodifierCNsmanagedobjectcontext1Appwindow1Window = app/*@START_MENU_TOKEN@*/.windows["SwiftUI.ModifiedContent<Ropes.ContentView, SwiftUI._EnvironmentKeyWritingModifier<__C.NSManagedObjectContext>>-1-AppWindow-1"]/*[[".windows[\"Ropes\"]",".windows[\"SwiftUI.ModifiedContent<Ropes.ContentView, SwiftUI._EnvironmentKeyWritingModifier<__C.NSManagedObjectContext>>-1-AppWindow-1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        XCUIApplication()/*@START_MENU_TOKEN@*/.windows["SwiftUI.ModifiedContent<Ropes.ContentView, SwiftUI._EnvironmentKeyWritingModifier<__C.NSManagedObjectContext>>-1-AppWindow-1"]/*[[".windows[\"Ropes\"]",".windows[\"SwiftUI.ModifiedContent<Ropes.ContentView, SwiftUI._EnvironmentKeyWritingModifier<__C.NSManagedObjectContext>>-1-AppWindow-1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.toolbars.buttons["ADD"].click()
        XCUIApplication()/*@START_MENU_TOKEN@*/.windows["Adding-AppWindow-1"].tables.buttons["Test"]/*[[".windows[\"Adding\"]",".groups",".scrollViews.tables",".tableRows",".cells.buttons[\"Test\"]",".buttons[\"Test\"]",".tables",".windows[\"Adding-AppWindow-1\"]"],[[[-1,7,1],[-1,0,1]],[[-1,6,3],[-1,2,3],[-1,1,2]],[[-1,6,3],[-1,2,3]],[[-1,5],[-1,4],[-1,3,4]],[[-1,5],[-1,4]]],[0,0,0]]@END_MENU_TOKEN@*/.click()
        swiftuiModifiedcontentRopesContentviewSwiftuiEnvironmentkeywritingmodifierCNsmanagedobjectcontext1Appwindow1Window.tables.buttons["Trash"].click()
        

        let menuBarsQuery2 = app.menuBars
        menuBarsQuery2.menuBarItems["Ropes"].click()
        menuBarsQuery2/*@START_MENU_TOKEN@*/.menuItems["showSettingsWindow:"]/*[[".menuBarItems[\"Ropes\"]",".menus",".menuItems[\"Settings…\"]",".menuItems[\"showSettingsWindow:\"]"],[[[-1,3],[-1,2],[-1,1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.click()
        app.windows["com_apple_SwiftUI_Settings_window"].tables.buttons["Trash"].firstMatch.click()
        

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    func testTime() {
        
        let app = XCUIApplication()
        app.launch()
        XCUIApplication()/*@START_MENU_TOKEN@*/.windows["SwiftUI.ModifiedContent<Ropes.ContentView, SwiftUI._EnvironmentKeyWritingModifier<__C.NSManagedObjectContext>>-1-AppWindow-1"].tables.buttons["DELETE ALL DATA"]/*[[".windows[\"Ropes\"]",".groups",".scrollViews.tables",".tableRows",".cells.buttons[\"DELETE ALL DATA\"]",".buttons[\"DELETE ALL DATA\"]",".tables",".windows[\"SwiftUI.ModifiedContent<Ropes.ContentView, SwiftUI._EnvironmentKeyWritingModifier<__C.NSManagedObjectContext>>-1-AppWindow-1\"]"],[[[-1,7,1],[-1,0,1]],[[-1,6,3],[-1,2,3],[-1,1,2]],[[-1,6,3],[-1,2,3]],[[-1,5],[-1,4],[-1,3,4]],[[-1,5],[-1,4]]],[0,0,0]]@END_MENU_TOKEN@*/.click()
        let menuBarsQuery = app.menuBars
        menuBarsQuery.menuBarItems["Ropes"].click()
        menuBarsQuery/*@START_MENU_TOKEN@*/.menuItems["showSettingsWindow:"]/*[[".menuBarItems[\"Ropes\"]",".menus",".menuItems[\"Settings…\"]",".menuItems[\"showSettingsWindow:\"]"],[[[-1,3],[-1,2],[-1,1,2],[-1,0,1]],[[-1,3],[-1,2],[-1,1,2]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.click()
        
        let comAppleSwiftuiSettingsWindowWindow = app/*@START_MENU_TOKEN@*/.windows["com_apple_SwiftUI_Settings_window"]/*[[".windows[\"settings\"]",".windows[\"com_apple_SwiftUI_Settings_window\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        comAppleSwiftuiSettingsWindowWindow/*@START_MENU_TOKEN@*/.tables.popUpButtons["5 minutes"]/*[[".groups",".scrollViews.tables",".tableRows",".cells.popUpButtons[\"5 minutes\"]",".popUpButtons[\"5 minutes\"]",".tables"],[[[-1,5,2],[-1,1,2],[-1,0,1]],[[-1,5,2],[-1,1,2]],[[-1,4],[-1,3],[-1,2,3]],[[-1,4],[-1,3]]],[0,0]]@END_MENU_TOKEN@*/.click()
        comAppleSwiftuiSettingsWindowWindow/*@START_MENU_TOKEN@*/.tables.menuItems["30 minutes"]/*[[".groups",".scrollViews.tables",".tableRows",".cells",".popUpButtons[\"5 minutes\"]",".menus.menuItems[\"30 minutes\"]",".menuItems[\"30 minutes\"]",".tables"],[[[-1,7,2],[-1,1,2],[-1,0,1]],[[-1,7,2],[-1,1,2]],[[-1,6],[-1,5],[-1,4,5],[-1,3,4],[-1,2,3]],[[-1,6],[-1,5],[-1,4,5],[-1,3,4]],[[-1,6],[-1,5],[-1,4,5]],[[-1,6],[-1,5]]],[0,0]]@END_MENU_TOKEN@*/.click()
        comAppleSwiftuiSettingsWindowWindow/*@START_MENU_TOKEN@*/.tables.popUpButtons["30 minutes"]/*[[".groups",".scrollViews.tables",".tableRows",".cells.popUpButtons[\"30 minutes\"]",".popUpButtons[\"30 minutes\"]",".tables"],[[[-1,5,2],[-1,1,2],[-1,0,1]],[[-1,5,2],[-1,1,2]],[[-1,4],[-1,3],[-1,2,3]],[[-1,4],[-1,3]]],[0,0]]@END_MENU_TOKEN@*/.click()
        comAppleSwiftuiSettingsWindowWindow/*@START_MENU_TOKEN@*/.tables.menuItems["5 minutes"]/*[[".groups",".scrollViews.tables",".tableRows",".cells",".popUpButtons[\"30 minutes\"]",".menus.menuItems[\"5 minutes\"]",".menuItems[\"5 minutes\"]",".tables"],[[[-1,7,2],[-1,1,2],[-1,0,1]],[[-1,7,2],[-1,1,2]],[[-1,6],[-1,5],[-1,4,5],[-1,3,4],[-1,2,3]],[[-1,6],[-1,5],[-1,4,5],[-1,3,4]],[[-1,6],[-1,5],[-1,4,5]],[[-1,6],[-1,5]]],[0,0]]@END_MENU_TOKEN@*/.click()
        
    }
}
