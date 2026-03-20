//
//  SearchUITests.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import XCTest

final class SearchUITests: XCTestCase {
    
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
    
    // MARK: - Search & Select Flow
    
    func test_searchCity_andSelectResult_displaysWeather() {
        // Given
        app.launchSkippingLocation()
        
        // When
        searchPage.searchAndSelectFirstResult("New York")
        
        // Then
        weatherPage.verifyWeatherDisplayed(for: "New York")
        weatherPage.verifyDetailCardsDisplayed()
    }
    
    func test_searchCity_showsResultsDropdown() {
        // Given
        app.launchSkippingLocation()
        
        // When
        searchPage.typeCity("London")
        
        // Then — results should appear after debounce
        searchPage.verifyResultsDisplayed(timeout: 5)
    }
    
    func test_clearSearch_removesText() {
        // Given
        app.launchSkippingLocation()
        searchPage.typeCity("Dallas")
        
        // When
        searchPage.clearSearch()
        
        // Then
        searchPage.verifySearchText("")
    }
    
    func test_searchDifferentCity_updatesWeather() {
        // Given
        app.launchSkippingLocation()
        searchPage.searchAndSelectFirstResult("Miami")
        weatherPage.verifyWeatherDisplayed(for: "Miami")
        
        // When — search a different city
        searchPage.clearSearch()
        searchPage.searchAndSelectFirstResult("Chicago")
        
        // Then
        weatherPage.verifyWeatherDisplayed(for: "Chicago")
    }
    
    func test_searchInvalidCity_noResults() {
        // Given
        app.launchSkippingLocation()
        
        // When
        searchPage.typeCity("xyznonexistentcity123")
        
        // Then — wait for debounce, no results should appear
        let firstResult = searchPage.searchResultCell(at: 0)
        // Wait a bit and verify no results appeared
        sleep(3) // Given more time, we'd use a better waiting mechanism
        XCTAssertFalse(firstResult.exists, "No results should appear for invalid city")
    }
}
