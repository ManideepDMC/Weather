//
//  NetworkService.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
    func downloadData(from url: URL) async throws -> Data
}

final class NetworkService: NetworkServiceProtocol {
    private let session: URLSession
    private let decoder: JSONDecoder
    
    init(session: URLSession = .shared) {
        self.session = session
        self.decoder = JSONDecoder()
        // OpenWeatherMap uses Unix timestamps for sunrise/sunset
        self.decoder.dateDecodingStrategy = .secondsSince1970
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        guard let url = endpoint.url else {
            throw WeatherError.invalidRequest
        }
        let (data, response) = try await performRequest(with: url)
        try validateResponse(response)
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw WeatherError.decodingError
        }
    }
    
    func downloadData(from url: URL) async throws -> Data {
        let (data, response) = try await performRequest(with: url)
        try validateResponse(response)
        return data
    }
    
    // MARK: - private helpers
    
    private func performRequest(with url: URL) async throws -> (Data, URLResponse) {
        do {
            return try await session.data(from: url)
        } catch {
            throw WeatherError.networkError
        }
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw WeatherError.networkError
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 404:
            throw WeatherError.cityNotFound
        case 400...499:
            throw WeatherError.networkError
        case 500...599:
            throw WeatherError.serverError(httpResponse.statusCode)
        default:
            throw WeatherError.unknown
        }
    }
}
