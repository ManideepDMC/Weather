//
//  WeatherRepositoryProtocol.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

protocol WeatherRepositoryProtocol {
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherEntity
    func searchCity(name: String) async throws -> [CityEntity]
}
