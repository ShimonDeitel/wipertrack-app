import XCTest

final class WiperBladeTrackerUITests: XCTestCase {
    func testAddEntryFlow() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        let saveButton = app.buttons["saveButton"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 3))
        saveButton.tap()
    }

    func testFreeLimitTriggersPaywall() {
        let app = XCUIApplication()
        app.launchArguments += ["-UITEST_FORCE_FREE_LIMIT"]
        app.launch()
        for _ in 0..<9 {
            app.buttons["addButton"].tap()
            if app.staticTexts["Wiper Blade Tracker Pro"].waitForExistence(timeout: 1) {
                break
            }
            let saveButton = app.buttons["saveButton"]
            if saveButton.waitForExistence(timeout: 1) {
                saveButton.tap()
            }
        }
        XCTAssertTrue(app.staticTexts["Wiper Blade Tracker Pro"].waitForExistence(timeout: 3))
    }

    func testKeyboardDismissOnTapOutside() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        let notesField = app.textFields["field_notes"]
        if notesField.waitForExistence(timeout: 2) {
            notesField.tap()
            app.navigationBars.firstMatch.tap()
            XCTAssertFalse(notesField.hasKeyboardFocus)
        }
    }

    func testCancelDismissesEditor() {
        let app = XCUIApplication()
        app.launch()
        app.buttons["addButton"].tap()
        app.buttons["cancelButton"].tap()
        XCTAssertTrue(app.buttons["addButton"].waitForExistence(timeout: 2))
    }
}
