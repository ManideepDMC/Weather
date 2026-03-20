//
//  SearchCityUseCase.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

import Foundation

protocol SearchCityUseCaseProtocol {
    func searchCity(query: String) async throws -> [CityEntity]
}

final class SearchCityUseCase: SearchCityUseCaseProtocol {
    private let weatherRepository: WeatherRepositoryProtocol
    
    init(weatherRepository: WeatherRepositoryProtocol) {
        self.weatherRepository = weatherRepository
    }
    
    func searchCity(query: String) async throws -> [CityEntity] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw WeatherError.invalidCity
        }
        return try await weatherRepository.searchCity(name: query)
    }
}
