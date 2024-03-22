//
//  TMDBUITests.swift
//  TMDBUITests
//
//  Created by LAP15284 on 22/03/2024.
//

import XCTest

final class TMDBUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadMore() throws {
        //assume that device has a network connection, or has cached more than 1 page of data before
        let app = XCUIApplication()
        app.launch()
        let initialTableRows = app.tables.children(matching: .cell).count
        app.tables.element.swipeUp()
        app.tables.element.swipeUp()
        app.tables.element.swipeUp()
        app.tables.element.swipeUp()
        app.tables.element.swipeUp()
        app.tables.element.swipeUp()
        app.tables.element.swipeUp()
        app.tables.element.swipeUp()
        app.tables.element.swipeUp()
        app.tables.element.swipeUp()
        let finalTableRows = app.tables.children(matching: .cell).count
        XCTAssert(initialTableRows < finalTableRows)
    }
    
    func testSearch() throws {
        let app = XCUIApplication()
        app.launch()
        let initialTableRows = app.tables.children(matching: .cell).count
        
        app.textFields.element.tap()
        app.textFields.element.typeText("Kung Fu Panda 4")
        
        //wait for the response
        sleep(3)

        let finalTableRows = app.tables.children(matching: .cell).count
        
        //assume that one page has 20 items at first, and the search action return 3 results
        XCTAssert(initialTableRows != finalTableRows)
    }
}
