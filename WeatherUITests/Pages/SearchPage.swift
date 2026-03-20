//
//  SearchPage.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import XCTest

/// Page object representing the search bar and results dropdown.
final class SearchPage {
    
    private let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    // MARK: - Elements
    
    var searchTextField: XCUIElement {
        app.textFields[AccessibilityID.searchTextField]
    }
    
    var clearButton: XCUIElement {
        app.buttons[AccessibilityID.searchClearButton]
    }
    
    var searchLoadingIndicator: XCUIElement {
        app.activityIndicators[AccessibilityID.searchLoadingIndicator]
    }
    
    func searchResultCell(at index: Int) -> XCUIElement {
        app.buttons[AccessibilityID.searchResultCell(index: index)]
    }
    
    // MARK: - Actions
    
    /// Types a city name into the search field
    func typeCity(_ name: String) {
        searchTextField.tap()
        searchTextField.typeText(name)
    }
    
    /// Clears the search field by selecting all text and deleting it.
    /// More reliable than tapping the clear button which can be blocked
    /// by the keyboard or search results overlay in UI tests.
    func clearSearch() {
        let textField = searchTextField
        textField.tap()

        // Get current text length and send that many delete keys
        guard let currentValue = textField.value as? String, !currentValue.isEmpty else { return }
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentValue.count)
        textField.typeText(deleteString)
    }
    
    /// Full search flow: type city name, wait for results, tap first result
    func searchAndSelectFirstResult(_ cityName: String, timeout: TimeInterval = 10) {
        typeCity(cityName)
        
        // Wait for search results to appear
        let firstResult = searchResultCell(at: 0)
        guard firstResult.waitForExistence(timeout: timeout) else {
            XCTFail("Search results did not appear for '\(cityName)'")
            return
        }
        
        firstResult.tap()
    }
    
    /// Verifies search results are visible
    func verifyResultsDisplayed(count: Int? = nil, timeout: TimeInterval = 10) {
        let firstResult = searchResultCell(at: 0)
        XCTAssertTrue(firstResult.waitForExistence(timeout: timeout), "At least one search result should appear")
        
        if let expectedCount = count {
            for i in 0..<expectedCount {
                XCTAssertTrue(searchResultCell(at: i).exists, "Result at index \(i) should exist")
            }
        }
    }
    
    /// Verifies the search field contains expected text
    func verifySearchText(_ expected: String) {
        let value = searchTextField.value as? String ?? ""
        if expected.isEmpty {
            // When empty, TextField shows placeholder or empty string
            let isEmptyOrPlaceholder = value.isEmpty || value == "Search US city..."
            XCTAssertTrue(isEmptyOrPlaceholder, "Search field should be empty, got: '\(value)'")
        } else {
            XCTAssertEqual(value, expected, "Search field should contain '\(expected)'")
        }
    }
}
