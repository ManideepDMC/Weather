//
//  MockSearchCityUseCase.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import Foundation
@testable import Weather

final class MockSearchCityUseCase: SearchCityUseCaseProtocol {
    
    var result: [CityEntity]?
    var error: Error?
    var executeCallCount = 0
    var lastQuery: String?
    
    func searchCity(query: String) async throws -> [CityEntity] {
        executeCallCount += 1
        lastQuery = query
        
        if let error = error {
            throw error
        }
        
        guard let result = result else {
            throw WeatherError.unknown
        }
        
        return result
    }
}
