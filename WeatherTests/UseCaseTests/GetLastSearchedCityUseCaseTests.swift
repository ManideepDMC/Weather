//
//  GetLastSearchedCityUseCaseTests.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import XCTest
@testable import Weather

final class GetLastSearchedCityUseCaseTests: XCTestCase {
    
    private var searchCityUseCase: GetLastSearchedCityUseCase!
    private var mockCacheRepository: MockCacheRepository!
    
    override func setUp() {
        super.setUp()
        mockCacheRepository = MockCacheRepository()
        searchCityUseCase = GetLastSearchedCityUseCase(cacheRepository: mockCacheRepository)
    }
    
    override func tearDown() {
        searchCityUseCase = nil
        mockCacheRepository = nil
        super.tearDown()
    }
    
    func test_get_noSavedCity_returnsNil() {
        // When
        let result = searchCityUseCase.getLastSearchedCity()
        
        // Then
        XCTAssertNil(result)
        XCTAssertEqual(mockCacheRepository.getCallCount, 1)
    }
    
    func test_get_hasSavedCity_returnsCity() {
        // Given
        mockCacheRepository.savedCity = TestData.makeCityEntity(name: "Seattle")
        
        // When
        let result = searchCityUseCase.getLastSearchedCity()
        
        // Then
        XCTAssertEqual(result?.name, "Seattle")
    }
    
    func test_save_callsRepository() {
        // Given
        let city = TestData.makeCityEntity(name: "Portland")
        
        // When
        searchCityUseCase.saveLastSearchedCity(city)
        
        // Then
        XCTAssertEqual(mockCacheRepository.saveCallCount, 1)
        XCTAssertEqual(mockCacheRepository.savedCity?.name, "Portland")
    }
}
