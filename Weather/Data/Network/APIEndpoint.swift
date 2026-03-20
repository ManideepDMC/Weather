//
//  APIEndpoint.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

import Foundation

enum APIEndpoint {
    case weather(latitude: Double, longitude: Double)
    case geoCoding(city: String)
    case weatherIcon(code: String)
    
    var url: URL? {
        switch self {
        case .weather(latitude: let latitude, longitude: let longitude):
            var components = URLComponents(string: APIConstants.baseURL + APIConstants.weatherPath)
            components?.queryItems = [
                URLQueryItem(name: "lat", value: String(latitude)),
                URLQueryItem(name: "lon", value: String(longitude)),
                URLQueryItem(name: "appid", value: APIConstants.apiKey),
                URLQueryItem(name: "units", value: "imperial") // Fahrenheit for US cities
            ]
            return components?.url
        case .geoCoding(city: let city):
            var components = URLComponents(string: APIConstants.baseURL + APIConstants.geocodingPath)
            components?.queryItems = [
                URLQueryItem(name: "q", value: city),
                URLQueryItem(name: "limit", value: "5"),
                URLQueryItem(name: "appid", value: APIConstants.apiKey)
            ]
            return components?.url
            
        case .weatherIcon(let code):
            return URL(string: "\(APIConstants.iconBaseURL)\(code)@2x.png")
        }
    }
}
