//
//  WeatherPage.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import XCTest

/// Page object representing the weather display section.
/// Encapsulates element queries so tests read like plain English.
final class WeatherPage {
    
    private let app: XCUIApplication
    
    init(app: XCUIApplication) {
        self.app = app
    }
    
    // MARK: - Elements
    
    var cityNameLabel: XCUIElement {
        app.staticTexts[AccessibilityID.cityNameLabel]
    }
    
    var temperatureLabel: XCUIElement {
        app.staticTexts[AccessibilityID.temperatureLabel]
    }
    
    var descriptionLabel: XCUIElement {
        app.staticTexts[AccessibilityID.descriptionLabel]
    }
    
    var weatherIcon: XCUIElement {
        app.images[AccessibilityID.weatherIcon]
    }
    
    var loadingView: XCUIElement {
        app.descendants(matching: .any)[AccessibilityID.loadingView].firstMatch
    }

    var errorView: XCUIElement {
        app.descendants(matching: .any)[AccessibilityID.errorView].firstMatch
    }

    var idleView: XCUIElement {
        app.descendants(matching: .any)[AccessibilityID.idleView].firstMatch
    }
    
    var retryButton: XCUIElement {
        app.buttons[AccessibilityID.retryButton]
    }
    
    // MARK: - Detail Cards
    
    var feelsLikeCard: XCUIElement {
        app.descendants(matching: .any)[AccessibilityID.feelsLikeCard].firstMatch
    }

    var humidityCard: XCUIElement {
        app.descendants(matching: .any)[AccessibilityID.humidityCard].firstMatch
    }

    var windCard: XCUIElement {
        app.descendants(matching: .any)[AccessibilityID.windCard].firstMatch
    }

    var visibilityCard: XCUIElement {
        app.descendants(matching: .any)[AccessibilityID.visibilityCard].firstMatch
    }

    var pressureCard: XCUIElement {
        app.descendants(matching: .any)[AccessibilityID.pressureCard].firstMatch
    }

    var sunriseCard: XCUIElement {
        app.descendants(matching: .any)[AccessibilityID.sunriseCard].firstMatch
    }

    var sunsetCard: XCUIElement {
        app.descendants(matching: .any)[AccessibilityID.sunsetCard].firstMatch
    }
    
    // MARK: - Assertions
    
    /// Verifies weather data is displayed for a given city
    func verifyWeatherDisplayed(for city: String, timeout: TimeInterval = 10) {
        XCTAssertTrue(cityNameLabel.waitForExistence(timeout: timeout), "City name should appear")
        XCTAssertEqual(cityNameLabel.label, city)
        XCTAssertTrue(temperatureLabel.exists, "Temperature should be visible")
        XCTAssertTrue(descriptionLabel.exists, "Description should be visible")
    }
    
    /// Verifies all detail cards are visible
    func verifyDetailCardsDisplayed() {
        XCTAssertTrue(feelsLikeCard.exists, "Feels like card should be visible")
        XCTAssertTrue(humidityCard.exists, "Humidity card should be visible")
        XCTAssertTrue(windCard.exists, "Wind card should be visible")
        XCTAssertTrue(visibilityCard.exists, "Visibility card should be visible")
    }
    
    /// Verifies the error state is shown
    func verifyErrorDisplayed(timeout: TimeInterval = 10) {
        XCTAssertTrue(errorView.waitForExistence(timeout: timeout), "Error view should appear")
        XCTAssertTrue(retryButton.exists, "Retry button should be visible")
    }
    
    /// Verifies the loading state is shown
    func verifyLoadingDisplayed(timeout: TimeInterval = 5) {
        XCTAssertTrue(loadingView.waitForExistence(timeout: timeout), "Loading view should appear")
    }
}
