//
//  LylaRenwick_Archibold_Lab3UITestsLaunchTests.swift
//  LylaRenwick-Archibold-Lab3UITests
//
//  Created by Lyla Renwick-Archibold on 9/29/23.
//

import XCTest

final class LylaRenwick_Archibold_Lab3UITestsLaunchTests: XCTestCase {

    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()

        // Insert steps here to perform after app launch but before taking a screenshot,
        // such as logging into a test account or navigating somewhere in the app

        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = "Launch Screen"
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
