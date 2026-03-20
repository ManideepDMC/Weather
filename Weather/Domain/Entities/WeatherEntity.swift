//
//  WeatherEntity.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

import Foundation

struct WeatherEntity {
    let cityName: String
    let temperature: Double // Kelvin from API, we'll convert in ViewModel
    let feelsLike: Double
    let tempMin: Double
    let tempMax: Double
    let pressure: Int // hPa
    let humidity: Int // percentage
    let seaLevel: Double // meters
    let groundLevel: Double // meters
    let windSpeed: Double // meters/sec
    let weatherDescription: String // e.g. "clear sky"
    let iconCode: String           // e.g. "01d" — used to build icon URL
    let visibility: Int            // meters
    let sunrise: Date
    let sunset: Date
}
