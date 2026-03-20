//
//  WeatherRepositoryTests.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import XCTest
@testable import Weather

@MainActor
final class WeatherRepositoryTests: XCTestCase {
    
    private var sut: WeatherRepository!  // System Under Test
    private var mockNetworkService: MockNetworkService!
    
    override func setUp() {
        super.setUp()
        mockNetworkService = MockNetworkService()
        sut = WeatherRepository(networkService: mockNetworkService)
    }
    
    override func tearDown() {
        sut = nil
        mockNetworkService = nil
        super.tearDown()
    }
    
    // MARK: - fetchWeather Tests
    
    func test_fetchWeather_success_returnsWeatherEntity() async throws {
        // Given
        let dto = TestData.makeWeatherResponseDTO()
        mockNetworkService.requestResult = dto
        
        // When
        let result = try await sut.fetchWeather(latitude: 40.71, longitude: -74.00)
        
        // Then
        XCTAssertEqual(result.cityName, "New York")
        XCTAssertEqual(result.temperature, 72.0)
        XCTAssertEqual(result.humidity, 64)
        XCTAssertEqual(result.weatherDescription, "clear sky")
        XCTAssertEqual(result.iconCode, "01d")
        XCTAssertEqual(mockNetworkService.requestCallCount, 1)
    }
    
    func test_fetchWeather_networkError_throwsError() async {
        // Given
        mockNetworkService.requestError = WeatherError.networkError
        
        // When / Then
        do {
            _ = try await sut.fetchWeather(latitude: 40.71, longitude: -74.00)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? WeatherError, .networkError)
        }
    }
    
    // MARK: - searchCity Tests
    
    func test_searchCity_success_returnsCityEntities() async throws {
        // Given
        let dtos = TestData.makeGeocodingResponseDTOs()
        mockNetworkService.requestResult = dtos
        
        // When
        let results = try await sut.searchCity(name: "New York")
        
        // Then
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, "New York")
        XCTAssertEqual(results.first?.state, "NY")
        XCTAssertEqual(results.first?.latitude, 40.7128)
    }
    
    func test_searchCity_emptyResponse_throwsCityNotFound() async {
        // Given
        let emptyDTOs: [GeocodingResponseDTO] = []
        mockNetworkService.requestResult = emptyDTOs
        
        // When / Then
        do {
            _ = try await sut.searchCity(name: "xyznonexistent")
            XCTFail("Expected cityNotFound error")
        } catch {
            XCTAssertEqual(error as? WeatherError, .cityNotFound)
        }
    }
    
    func test_searchCity_networkError_throwsError() async {
        // Given
        mockNetworkService.requestError = WeatherError.serverError(500)
        
        // When / Then
        do {
            _ = try await sut.searchCity(name: "New York")
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertEqual(error as? WeatherError, .serverError(500))
        }
    }
}
