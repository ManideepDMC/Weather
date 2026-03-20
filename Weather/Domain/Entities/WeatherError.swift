//
//  WeatherError.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

import Foundation

enum WeatherError: LocalizedError, Equatable {
    case invalidCity
    case cityNotFound
    case invalidRequest
    case networkError
    case decodingError
    case locationDenied
    case locationUnavailable
    case serverError(Int)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .invalidCity:
            return "Please enter a valid city name."
        case .cityNotFound:
            return "City not found. Please check the name and try again."
        case .invalidRequest:
            return "The request is invalid. Please try again later."
        case .networkError:
            return "Unable to connect. Please check your internet connection."
        case .decodingError:
            return "Something went wrong while processing weather data."
        case .locationDenied:
            return "Location access denied. Please enable it in Settings."
        case .locationUnavailable:
            return "Unable to determine your location."
        case .serverError(let code):
            return "Server error (\(code)). Please try again later."
        case .unknown:
            return "An unexpected error occurred."
        }
    }
    
    // MARK: - Equatable
    static func == (lhs: WeatherError, rhs: WeatherError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidCity, .invalidCity),
             (.cityNotFound, .cityNotFound),
             (.invalidRequest, .invalidRequest),
             (.networkError, .networkError),
             (.decodingError, .decodingError),
             (.locationDenied, .locationDenied),
             (.locationUnavailable, .locationUnavailable),
             (.unknown, .unknown):
            return true
        case let (.serverError(a), .serverError(b)):
            return a == b
        default:
            return false
        }
    }
}
