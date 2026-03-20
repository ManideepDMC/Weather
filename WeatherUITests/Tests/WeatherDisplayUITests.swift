//
//  WeatherDisplayUITests.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import XCTest

final class WeatherDisplayUITests: XCTestCase {
    
    private var app: XCUIApplication!
    private var searchPage: SearchPage!
    private var weatherPage: WeatherPage!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        searchPage = SearchPage(app: app)
        weatherPage = WeatherPage(app: app)
    }
    
    override func tearDown() {
        app = nil
        searchPage = nil
        weatherPage = nil
        super.tearDown()
    }
    
    // MARK: - Weather Data Display
    
    func test_weatherLoaded_showsAllDetailCards() {
        // Given
        app.launchSkippingLocation()
        
        // When
        searchPage.searchAndSelectFirstResult("New York")
        
        // Then — verify all cards exist
        weatherPage.verifyWeatherDisplayed(for: "New York")
        
        // Scroll down to see all cards if needed
        app.swipeUp()
        
        XCTAssertTrue(weatherPage.feelsLikeCard.exists, "Feels like card should be visible")
        XCTAssertTrue(weatherPage.humidityCard.exists, "Humidity card should be visible")
        XCTAssertTrue(weatherPage.windCard.exists, "Wind card should be visible")
        XCTAssertTrue(weatherPage.visibilityCard.exists, "Visibility card should be visible")
        XCTAssertTrue(weatherPage.pressureCard.exists, "Pressure card should be visible")
        XCTAssertTrue(weatherPage.sunriseCard.exists, "Sunrise card should be visible")
        XCTAssertTrue(weatherPage.sunsetCard.exists, "Sunset card should be visible")
    }
    
    func test_weatherLoaded_showsWeatherIcon() {
        // Given
        app.launchSkippingLocation()
        
        // When
        searchPage.searchAndSelectFirstResult("Miami")
        weatherPage.verifyWeatherDisplayed(for: "Miami")
        
        // Then — icon should load (with extra time for network)
        XCTAssertTrue(
            weatherPage.weatherIcon.waitForExistence(timeout: 15),
            "Weather icon should load from API"
        )
    }
    
    func test_temperatureLabel_containsDegreeSymbol() {
        // Given
        app.launchSkippingLocation()
        
        // When
        searchPage.searchAndSelectFirstResult("Dallas")
        weatherPage.verifyWeatherDisplayed(for: "Dallas")
        
        // Then
        let tempText = weatherPage.temperatureLabel.label
        XCTAssertTrue(tempText.contains("°F"), "Temperature should show °F, got: \(tempText)")
    }
    
    // MARK: - Landscape
    
    func test_landscape_displaysWeatherCorrectly() {
        // Given
        app.launchSkippingLocation()
        searchPage.searchAndSelectFirstResult("Seattle")
        weatherPage.verifyWeatherDisplayed(for: "Seattle")
        
        // When — rotate to landscape
        XCUIDevice.shared.orientation = .landscapeLeft
        
        // Then — weather should still be visible
        XCTAssertTrue(weatherPage.cityNameLabel.exists, "City name should be visible in landscape")
        XCTAssertTrue(weatherPage.temperatureLabel.exists, "Temperature should be visible in landscape")
        
        // Reset orientation
        XCUIDevice.shared.orientation = .portrait
    }
}
