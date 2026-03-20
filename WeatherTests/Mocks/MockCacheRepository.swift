//
//  MockCacheRepository.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import Foundation
@testable import Weather

final class MockCacheRepository: CacheRepositoryProtocol {
    
    // MARK: - Storage
    var savedCity: CityEntity?
    var saveCallCount = 0
    var getCallCount = 0
    
    func saveLastSearchedCity(_ city: CityEntity) {
        saveCallCount += 1
        savedCity = city
    }
    
    func getLastSearchedCity() -> CityEntity? {
        getCallCount += 1
        return savedCity
    }
}
