//
//  FetchWeatherUseCaseTests.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import XCTest
@testable import Weather

@MainActor
final class FetchWeatherUseCaseTests: XCTestCase {
    
    private var weatherUseCase: FetchWeatherUseCase!
    private var mockRepository: MockWeatherRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockWeatherRepository()
        weatherUseCase = FetchWeatherUseCase(weatherRepository: mockRepository)
    }
    
    override func tearDown() {
        weatherUseCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func test_execute_success_returnsWeather() async throws {
        // Given
        let expected = TestData.makeWeatherEntity(cityName: "Miami", temperature: 85.0)
        mockRepository.fetchWeatherResult = expected
        
        // When
        let result = try await weatherUseCase.fetchWeather(latitude: 25.76, longitude: -80.19)
        
        // Then
        XCTAssertEqual(result.cityName, "Miami")
        XCTAssertEqual(result.temperature, 85.0)
        XCTAssertEqual(mockRepository.fetchWeatherCallCount, 1)
        XCTAssertEqual(mockRepository.fetchWeatherLatitude, 25.76)
        XCTAssertEqual(mockRepository.fetchWeatherLongitude, -80.19)
    }
    
    func test_execute_repositoryThrows_propagatesError() async {
        // Given
        mockRepository.fetchWeatherError = WeatherError.networkError
        
        // When / Then
        do {
            _ = try await weatherUseCase.fetchWeather(latitude: 25.76, longitude: -80.19)
            XCTFail("Expected error")
        } catch {
            XCTAssertEqual(error as? WeatherError, .networkError)
        }
    }
}
