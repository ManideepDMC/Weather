//
//  WeatherRepository.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

import Foundation

final class WeatherRepository: WeatherRepositoryProtocol {
    private let networkService: NetworkServiceProtocol
        
    init(networkService: NetworkServiceProtocol) {
        self.networkService = networkService
    }
    
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherEntity {
        let dto: WeatherResponseDTO = try await networkService.request(.weather(latitude: latitude, longitude: longitude))
        return dto.toDomain()
    }
    
    func searchCity(name: String) async throws -> [CityEntity] {
        let dtos: [GeocodingResponseDTO] = try await networkService.request(.geoCoding(city: name))
        guard !dtos.isEmpty else {
            throw WeatherError.cityNotFound
        }
        return dtos.map { $0.toDomain() }
    }
}
