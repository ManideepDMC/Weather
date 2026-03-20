//
//  TestData.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import Foundation
@testable import Weather

/// Provides reusable test data across all test files.
enum TestData {
    
    static func makeWeatherEntity(
        cityName: String = "New York",
        temperature: Double = 72.0,
        feelsLike: Double = 70.0,
        tempMin: Double = 65.0,
        tempMax: Double = 78.0,
        humidity: Int = 64,
        pressure: Int = 1013,
        seaLevel: Double = 1021.2,
        groundLevel: Double = 993.5,
        windSpeed: Double = 11.5,
        weatherDescription: String = "clear sky",
        iconCode: String = "01d",
        visibility: Int = 10000,
        sunrise: Date = Date(),
        sunset: Date = Date()
    ) -> WeatherEntity {
        WeatherEntity(
            cityName: cityName,
            temperature: temperature,
            feelsLike: feelsLike,
            tempMin: tempMin,
            tempMax: tempMax,
            pressure: pressure,
            humidity: humidity,
            seaLevel: seaLevel,
            groundLevel: groundLevel,
            windSpeed: windSpeed,
            weatherDescription: weatherDescription,
            iconCode: iconCode,
            visibility: visibility,
            sunrise: sunrise,
            sunset: sunset
        )
    }
    
    static func makeCityEntity(
        name: String = "New York",
        state: String? = "NY",
        country: String = "US",
        latitude: Double = 40.7128,
        longitude: Double = -74.0060
    ) -> CityEntity {
        CityEntity(
            name: name,
            state: state,
            country: country,
            latitude: latitude,
            longitude: longitude
        )
    }
    
    static func makeLocationEntity(
        latitude: Double = 40.7128,
        longitude: Double = -74.0060
    ) -> LocationEntity {
        LocationEntity(
            latitude: latitude,
            longitude: longitude
        )
    }
    
    // MARK: - DTOs for Repository Tests
    
    static func makeWeatherResponseDTO() -> WeatherResponseDTO {
        WeatherResponseDTO(
            name: "New York",
            main: MainDTO(
                temp: 72.0,
                feelsLike: 70.0,
                tempMin: 65.0,
                tempMax: 78.0,
                humidity: 64,
                pressure: 1013,
                seaLevel: 1021.2,
                groundLevel: 993.5
            ),
            weather: [
                WeatherDetailDTO(description: "clear sky", icon: "01d")
            ],
            wind: WindDTO(speed: 11.5),
            visibility: 10000,
            sys: SysDTO(
                sunrise: Date(timeIntervalSince1970: 1700000000),
                sunset: Date(timeIntervalSince1970: 1700040000)
            )
        )
    }
    
    static func makeGeocodingResponseDTOs() -> [GeocodingResponseDTO] {
        [
            GeocodingResponseDTO(
                name: "New York",
                state: "NY",
                country: "US",
                lat: 40.7128,
                lon: -74.0060
            )
        ]
    }
}
