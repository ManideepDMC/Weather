//
//  CacheRepositoryTests.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import XCTest
@testable import Weather

final class CacheRepositoryTests: XCTestCase {
    
    private var sut: CacheRepository!
    private var testDefaults: UserDefaults!
    
    override func setUp() {
        super.setUp()
        // Use a separate UserDefaults suite for testing — doesn't affect real app data
        testDefaults = UserDefaults(suiteName: "com.weather.tests")
        testDefaults.removePersistentDomain(forName: "com.weather.tests")
        sut = CacheRepository(userDefaults: testDefaults)
    }
    
    override func tearDown() {
        testDefaults.removePersistentDomain(forName: "com.weather.tests")
        testDefaults = nil
        sut = nil
        super.tearDown()
    }
    
    func test_getLastSearchedCity_noData_returnsNil() {
        // When
        let result = sut.getLastSearchedCity()
        
        // Then
        XCTAssertNil(result)
    }
    
    func test_saveAndGet_roundTrip_returnsCorrectCity() {
        // Given
        let city = TestData.makeCityEntity(
            name: "Chicago",
            state: "IL",
            country: "US",
            latitude: 41.8781,
            longitude: -87.6298
        )
        
        // When
        sut.saveLastSearchedCity(city)
        let result = sut.getLastSearchedCity()
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertEqual(result?.name, "Chicago")
        XCTAssertEqual(result?.state, "IL")
        XCTAssertEqual(result?.country, "US")
        XCTAssertEqual(result?.latitude, 41.8781)
        XCTAssertEqual(result?.longitude, -87.6298)
    }
    
    func test_save_overwritesPreviousCity() {
        // Given
        let firstCity = TestData.makeCityEntity(name: "Chicago")
        let secondCity = TestData.makeCityEntity(name: "Boston", state: "MA")
        
        // When
        sut.saveLastSearchedCity(firstCity)
        sut.saveLastSearchedCity(secondCity)
        let result = sut.getLastSearchedCity()
        
        // Then
        XCTAssertEqual(result?.name, "Boston")
        XCTAssertEqual(result?.state, "MA")
    }
    
    func test_getCity_withNilState_returnsNilState() {
        // Given — non-US city with no state
        let city = TestData.makeCityEntity(name: "London", state: nil, country: "GB")
        
        // When
        sut.saveLastSearchedCity(city)
        let result = sut.getLastSearchedCity()
        
        // Then
        XCTAssertNotNil(result)
        XCTAssertNil(result?.state)
        XCTAssertEqual(result?.country, "GB")
    }
}
