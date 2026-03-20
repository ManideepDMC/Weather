//
//  SearchCityUseCaseTests.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import XCTest
@testable import Weather

@MainActor
final class SearchCityUseCaseTests: XCTestCase {
    
    private var searchCityUseCase: SearchCityUseCase!
    private var mockRepository: MockWeatherRepository!
    
    override func setUp() {
        super.setUp()
        mockRepository = MockWeatherRepository()
        searchCityUseCase = SearchCityUseCase(weatherRepository: mockRepository)
    }
    
    override func tearDown() {
        searchCityUseCase = nil
        mockRepository = nil
        super.tearDown()
    }
    
    func test_execute_validQuery_returnsCities() async throws {
        // Given
        let cities = [TestData.makeCityEntity(name: "Dallas")]
        mockRepository.searchCityResult = cities
        
        // When
        let result = try await searchCityUseCase.searchCity(query: "Dallas")
        
        // Then
        XCTAssertEqual(result.count, 1)
        XCTAssertEqual(result.first?.name, "Dallas")
        XCTAssertEqual(mockRepository.searchCityCallCount, 1)
    }
    
    func test_execute_emptyQuery_throwsInvalidCity() async {
        // When / Then
        do {
            _ = try await searchCityUseCase.searchCity(query: "")
            XCTFail("Expected invalidCity error")
        } catch {
            XCTAssertEqual(error as? WeatherError, .invalidCity)
        }
        
        // Repository should NOT be called for empty queries
        XCTAssertEqual(mockRepository.searchCityCallCount, 0)
    }
    
    func test_execute_whitespaceOnlyQuery_throwsInvalidCity() async {
        // When / Then
        do {
            _ = try await searchCityUseCase.searchCity(query: "   ")
            XCTFail("Expected invalidCity error")
        } catch {
            XCTAssertEqual(error as? WeatherError, .invalidCity)
        }
        
        XCTAssertEqual(mockRepository.searchCityCallCount, 0)
    }
    
    func test_execute_queryWithSpaces_trimsAndSearches() async throws {
        // Given
        mockRepository.searchCityResult = [TestData.makeCityEntity()]
        
        // When
        _ = try await searchCityUseCase.searchCity(query: "  New York  ")
        
        // Then — verify trimmed query was passed to repository
        XCTAssertEqual(mockRepository.searchCityQuery, "  New York  ")
    }
    
    func test_execute_repositoryThrows_propagatesError() async {
        // Given
        mockRepository.searchCityError = WeatherError.cityNotFound
        
        // When / Then
        do {
            _ = try await searchCityUseCase.searchCity(query: "xyznonexistent")
            XCTFail("Expected cityNotFound error")
        } catch {
            XCTAssertEqual(error as? WeatherError, .cityNotFound)
        }
    }
}
