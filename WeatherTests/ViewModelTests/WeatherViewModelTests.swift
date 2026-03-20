//
//  WeatherViewModelTests.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import XCTest
import Combine
@testable import Weather

@MainActor
final class WeatherViewModelTests: XCTestCase {
    
    private var sut: WeatherViewModel!
    private var mockFetchWeather: MockFetchWeatherUseCase!
    private var mockSearchCity: MockSearchCityUseCase!
    private var mockLastSearchedCity: MockGetLastSearchedCityUseCase!
    private var mockCurrentLocation: MockGetCurrentLocationUseCase!
    private var mockImageCache: MockImageCacheService!
    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        mockFetchWeather = MockFetchWeatherUseCase()
        mockSearchCity = MockSearchCityUseCase()
        mockLastSearchedCity = MockGetLastSearchedCityUseCase()
        mockCurrentLocation = MockGetCurrentLocationUseCase()
        mockImageCache = MockImageCacheService()
        cancellables = []
        
        sut = WeatherViewModel(
            fetchWeatherUseCase: mockFetchWeather,
            searchCityUseCase: mockSearchCity,
            lastSearchedCityUseCase: mockLastSearchedCity,
            currentLocationUseCase: mockCurrentLocation,
            imageCacheService: mockImageCache
        )
    }
    
    override func tearDown() {
        sut = nil
        mockFetchWeather = nil
        mockSearchCity = nil
        mockLastSearchedCity = nil
        mockCurrentLocation = nil
        mockImageCache = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - App Launch: Last Searched City
    
    func test_onAppear_withLastSearchedCity_fetchesWeather() async {
        // Given
        let city = TestData.makeCityEntity(name: "Denver")
        mockLastSearchedCity.savedCity = city
        let weather = TestData.makeWeatherEntity(cityName: "Denver")
        mockFetchWeather.result = weather
        mockImageCache.loadImageResult = Data()
        
        // When
        sut.onAppear()
        
        // Wait for async tasks to complete
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5s
        
        // Then
        XCTAssertEqual(sut.searchText, "Denver")
        XCTAssertEqual(mockFetchWeather.executeCallCount, 1)
        XCTAssertEqual(mockFetchWeather.lastLatitude, city.latitude)
        if case .loaded(let entity) = sut.viewState {
            XCTAssertEqual(entity.cityName, "Denver")
        } else {
            XCTFail("Expected loaded state, got \(sut.viewState)")
        }
    }
    
    // MARK: - App Launch: No Cache, Location Granted
    
    func test_onAppear_noCache_locationGranted_fetchesWeatherForLocation() async {
        // Given — no cached city
        mockLastSearchedCity.savedCity = nil
        mockCurrentLocation.permissionResult = true
        mockCurrentLocation.locationResult = TestData.makeLocationEntity()
        mockFetchWeather.result = TestData.makeWeatherEntity()
        mockImageCache.loadImageResult = Data()
        
        // When
        sut.onAppear()
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Then
        XCTAssertEqual(mockCurrentLocation.requestPermissionCallCount, 1)
        XCTAssertEqual(mockCurrentLocation.executeCallCount, 1)
        XCTAssertEqual(mockFetchWeather.executeCallCount, 1)
    }
    
    // MARK: - App Launch: No Cache, Location Denied
    
    func test_onAppear_noCache_locationDenied_staysIdle() async {
        // Given
        mockLastSearchedCity.savedCity = nil
        mockCurrentLocation.permissionResult = false
        
        // When
        sut.onAppear()
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Then
        XCTAssertEqual(mockCurrentLocation.requestPermissionCallCount, 1)
        XCTAssertEqual(mockFetchWeather.executeCallCount, 0) // No weather fetch
    }
    
    // MARK: - City Selection
    
    func test_selectCity_savesAndFetchesWeather() async {
        // Given
        let city = TestData.makeCityEntity(name: "Austin", state: "TX")
        mockFetchWeather.result = TestData.makeWeatherEntity(cityName: "Austin")
        mockImageCache.loadImageResult = Data()
        
        // When
        sut.selectCity(city)
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Then
        XCTAssertEqual(sut.searchText, "Austin")
        XCTAssertTrue(sut.searchResults.isEmpty, "Search results should clear after selection")
        XCTAssertEqual(mockLastSearchedCity.saveCallCount, 1)
        XCTAssertEqual(mockLastSearchedCity.savedCity?.name, "Austin")
        XCTAssertEqual(mockFetchWeather.executeCallCount, 1)
    }
    
    // MARK: - Error Handling
    
    func test_fetchWeather_failure_setsErrorState() async {
        // Given
        let city = TestData.makeCityEntity()
        mockFetchWeather.error = WeatherError.networkError
        
        // When
        sut.selectCity(city)
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Then
        if case .error(let message) = sut.viewState {
            XCTAssertEqual(message, WeatherError.networkError.localizedDescription)
        } else {
            XCTFail("Expected error state, got \(sut.viewState)")
        }
    }
    
    // MARK: - Icon Loading
    
    func test_fetchWeather_success_loadsIcon() async {
        // Given
        let weather = TestData.makeWeatherEntity(iconCode: "10d")
        mockFetchWeather.result = weather
        let fakeImageData = Data([0x89, 0x50, 0x4E, 0x47]) // PNG header bytes
        mockImageCache.loadImageResult = fakeImageData
        
        // When
        sut.selectCity(TestData.makeCityEntity())
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Then
        XCTAssertEqual(mockImageCache.loadImageCallCount, 1)
        XCTAssertEqual(mockImageCache.lastRequestedIconCode, "10d")
        XCTAssertNotNil(sut.weatherIconData)
    }
    
    func test_iconLoadFailure_doesNotAffectWeatherState() async {
        // Given
        mockFetchWeather.result = TestData.makeWeatherEntity()
        mockImageCache.loadImageError = WeatherError.networkError
        
        // When
        sut.selectCity(TestData.makeCityEntity())
        try? await Task.sleep(nanoseconds: 500_000_000)
        
        // Then — weather still loaded despite icon failure
        if case .loaded = sut.viewState {
            // Success — weather shows even though icon failed
        } else {
            XCTFail("Weather should still be loaded even if icon fails")
        }
        XCTAssertNil(sut.weatherIconData)
    }
    
    // MARK: - Formatting Helpers
    
    func test_formattedTemperature_roundsCorrectly() {
        XCTAssertEqual(sut.formattedTemperature(72.4), "72°F")
        XCTAssertEqual(sut.formattedTemperature(72.6), "73°F")
        XCTAssertEqual(sut.formattedTemperature(0.0), "0°F")
        XCTAssertEqual(sut.formattedTemperature(-5.3), "-5°F")
    }
    
    func test_formattedDescription_capitalizes() {
        XCTAssertEqual(sut.formattedDescription("clear sky"), "Clear Sky")
        XCTAssertEqual(sut.formattedDescription("light rain"), "Light Rain")
    }
    
    func test_formattedWindSpeed_formatsCorrectly() {
        XCTAssertEqual(sut.formattedWindSpeed(11.5), "11.5 mph")
        XCTAssertEqual(sut.formattedWindSpeed(0.0), "0.0 mph")
    }
    
    func test_formattedVisibility_convertsMetersToMiles() {
        // 10000 meters = 6.2 miles
        XCTAssertEqual(sut.formattedVisibility(10000), "6.2 mi")
    }
}
