//
//  FetchWeatherUseCase.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

import Foundation

protocol FetchWeatherUseCaseProtocol {
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherEntity
}


final class FetchWeatherUseCase: FetchWeatherUseCaseProtocol {
    private let weatherRepository: WeatherRepositoryProtocol
    
    init(weatherRepository: WeatherRepositoryProtocol) {
        self.weatherRepository = weatherRepository
    }
    
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherEntity {
        try await weatherRepository.fetchWeather(latitude: latitude, longitude: longitude)
    }
    
}
