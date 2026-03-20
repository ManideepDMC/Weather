//
//  MockNetworkService.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import Foundation
@testable import Weather

final class MockNetworkService: NetworkServiceProtocol {
    
    // MARK: - Configurable Results
    var requestResult: Any?
    var requestError: Error?
    var downloadDataResult: Data?
    var downloadDataError: Error?
    
    // MARK: - Call Tracking
    var requestCallCount = 0
    var downloadDataCallCount = 0
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        requestCallCount += 1
        
        if let error = requestError {
            throw error
        }
        
        guard let result = requestResult as? T else {
            throw WeatherError.decodingError
        }
        
        return result
    }
    
    func downloadData(from url: URL) async throws -> Data {
        downloadDataCallCount += 1
        
        if let error = downloadDataError {
            throw error
        }
        
        guard let data = downloadDataResult else {
            throw WeatherError.networkError
        }
        
        return data
    }
}
