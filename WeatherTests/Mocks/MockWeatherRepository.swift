//
//  MockWeatherRepository.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import Foundation
@testable import Weather

final class MockWeatherRepository: WeatherRepositoryProtocol {
    
    // MARK: - fetchWeather
    var fetchWeatherResult: WeatherEntity?
    var fetchWeatherError: Error?
    var fetchWeatherCallCount = 0
    var fetchWeatherLatitude: Double?
    var fetchWeatherLongitude: Double?
    
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherEntity {
        fetchWeatherCallCount += 1
        fetchWeatherLatitude = latitude
        fetchWeatherLongitude = longitude
        
        if let error = fetchWeatherError {
            throw error
        }
        
        guard let result = fetchWeatherResult else {
            throw WeatherError.unknown
        }
        
        return result
    }
    
    // MARK: - searchCity
    var searchCityResult: [CityEntity]?
    var searchCityError: Error?
    var searchCityCallCount = 0
    var searchCityQuery: String?
    
    func searchCity(name: String) async throws -> [CityEntity] {
        searchCityCallCount += 1
        searchCityQuery = name
        
        if let error = searchCityError {
            throw error
        }
        
        guard let result = searchCityResult else {
            throw WeatherError.unknown
        }
        
        return result
    }
}
