//
//  AGLEditorSwiftUITests.swift
//  AGLEditorSwiftUITests
//
//  Created by retro on 19/08/2023.
//

import XCTest

final class AGLEditorSwiftUITests: XCTestCase {
    
    var app: XCUIApplication!
    var inputEditor: XCUIElement!
    var outputEditor: XCUIElement!
    var modePicker: XCUIElement!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        app = XCUIApplication()
        app.launch()
        inputEditor = app.textViews["inputEditor"]
        outputEditor = app.textViews["outputEditor"]
        modePicker = app.segmentedControls["modePicker"]
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInvalidCode() throws {
        // Write invalid code "abc" into the input
        inputEditor.clearAndEnterText("abc")
        // Check output is "failed to compile"
        XCTAssertEqual(outputEditor.value as! String, "failed to compile")
    }
    
    func testValidCode() throws {
        // Write valid code into the input
        inputEditor.clearAndEnterText("write(8, 0x681C8, 5 + 1);")
        XCTAssertEqual(outputEditor.value as! String, "300681c8 0006")
    }
    
    func testValidCodePlatformSwitch() {
        inputEditor.clearAndEnterText("write(8, 0x681C8, 5 + 1);")
        XCTAssertEqual(outputEditor.value as! String, "300681c8 0006")
        modePicker.buttons["N64"].tap()
        XCTAssertEqual(outputEditor.value as! String, "800681c8 0006")
        modePicker.buttons["PSX"].tap()
        XCTAssertEqual(outputEditor.value as! String, "300681c8 0006")
    }

//    func testLaunchPerformance() throws {
//        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
//            // This measures how long it takes to launch your application.
//            measure(metrics: [XCTApplicationLaunchMetric()]) {
//                XCUIApplication().launch()
//            }
//        }
//    }
}

extension XCUIElement {
    /**
     Removes any current text in the field before typing in the new value
     - Parameter text: the text to enter into the field
     */
    func clearAndEnterText(_ text: String) {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }

        self.tap()

        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)

        self.typeText(deleteString)
        self.typeText(text)
    }
}
