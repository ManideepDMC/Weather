//
//  WeatherResponseDTO.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

import Foundation

// MARK: - Top-level response
struct WeatherResponseDTO: Decodable {
    let name: String
    let main: MainDTO
    let weather: [WeatherDetailDTO]
    let wind: WindDTO
    let visibility: Int
    let sys: SysDTO
}

// MARK: - Nested DTOs matching API JSON structure
struct MainDTO: Decodable {
    let temp: Double
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let humidity: Int
    let pressure: Int
    let seaLevel: Double
    let groundLevel: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevel = "sea_level"
        case groundLevel = "grnd_level"
        case humidity
        case pressure
    }
}

struct WeatherDetailDTO: Decodable {
    let description: String
    let icon: String
}

struct WindDTO: Decodable {
    let speed: Double
}

struct SysDTO: Decodable {
    let sunrise: Date
    let sunset: Date
}

// MARK: - Mapping DTO → Domain Entity
extension WeatherResponseDTO {
    func toDomain() -> WeatherEntity {
        WeatherEntity(
            cityName: name,
            temperature: main.temp,
            feelsLike: main.feelsLike,
            tempMin: main.tempMin,
            tempMax: main.tempMax,
            pressure: main.pressure,
            humidity: main.humidity,
            seaLevel: main.seaLevel,
            groundLevel: main.groundLevel,
            windSpeed: wind.speed,
            // Defensive: API guarantees at least one weather item, but we guard anyway
            weatherDescription: weather.first?.description ?? "N/A",
            iconCode: weather.first?.icon ?? "01d",
            visibility: visibility,
            sunrise: sys.sunrise,
            sunset: sys.sunset
        )
    }
}
