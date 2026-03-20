//
//  MockImageCacheService.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import Foundation
@testable import Weather

final class MockImageCacheService: ImageCacheServiceProtocol {
    
    var loadImageResult: Data?
    var loadImageError: Error?
    var loadImageCallCount = 0
    var lastRequestedIconCode: String?
    
    func loadImage(for iconCode: String) async throws -> Data {
        loadImageCallCount += 1
        lastRequestedIconCode = iconCode
        
        if let error = loadImageError {
            throw error
        }
        
        guard let data = loadImageResult else {
            throw WeatherError.networkError
        }
        
        return data
    }
}
