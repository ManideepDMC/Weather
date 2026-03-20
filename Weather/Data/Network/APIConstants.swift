//
//  APIConstants.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

import Foundation

enum APIConstants {
    static let baseURL = "https://api.openweathermap.org"
    static let apiKey = "9cb44331cf4d0d11361d0a51eb3bf3d6" // TODO: Move to secure storage (e.g., Keychain or xcconfig) for production
    static let weatherPath = "/data/2.5/weather"
    static let geocodingPath = "/geo/1.0/direct"
    static let iconBaseURL = "https://openweathermap.org/img/wn/"
}
