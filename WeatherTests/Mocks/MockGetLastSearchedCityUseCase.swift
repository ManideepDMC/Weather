//
//  MockGetLastSearchedCityUseCase.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import Foundation
@testable import Weather

final class MockGetLastSearchedCityUseCase: GetLastSearchedCityUseCaseProtocol {
    
    var savedCity: CityEntity?
    var getCallCount = 0
    var saveCallCount = 0
    
    func getLastSearchedCity() -> CityEntity? {
        getCallCount += 1
        return savedCity
    }
    
    func saveLastSearchedCity(_ city: CityEntity) {
        saveCallCount += 1
        savedCity = city
    }
}
