//
//  MockLocationRepository.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import Foundation
@testable import Weather

final class MockLocationRepository: LocationRepositoryProtocol {
    
    // MARK: - getCurrentLocation
    var currentLocationResult: LocationEntity?
    var currentLocationError: Error?
    var getCurrentLocationCallCount = 0
    
    func getCurrentLocation() async throws -> LocationEntity {
        getCurrentLocationCallCount += 1
        
        if let error = currentLocationError {
            throw error
        }
        
        guard let result = currentLocationResult else {
            throw WeatherError.locationUnavailable
        }
        
        return result
    }
    
    // MARK: - requestPermission
    var permissionResult: Bool = true
    var requestPermissionCallCount = 0
    
    func requestPermission() async -> Bool {
        requestPermissionCallCount += 1
        return permissionResult
    }
}
