//
//  MockFetchWeatherUseCase.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import Foundation
@testable import Weather

final class MockFetchWeatherUseCase: FetchWeatherUseCaseProtocol {
    
    var result: WeatherEntity?
    var error: Error?
    var executeCallCount = 0
    var lastLatitude: Double?
    var lastLongitude: Double?
    
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherEntity {
        executeCallCount += 1
        lastLatitude = latitude
        lastLongitude = longitude
        
        if let error = error {
            throw error
        }
        
        guard let result = result else {
            throw WeatherError.unknown
        }
        
        return result
    }
}
