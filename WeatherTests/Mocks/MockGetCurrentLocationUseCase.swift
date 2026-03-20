//
//  MockGetCurrentLocationUseCase.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import Foundation
@testable import Weather

final class MockGetCurrentLocationUseCase: GetCurrentLocationUseCaseProtocol {
    
    var locationResult: LocationEntity?
    var locationError: Error?
    var permissionResult: Bool = true
    var executeCallCount = 0
    var requestPermissionCallCount = 0
    
    func getCurrentLocation() async throws -> LocationEntity {
        executeCallCount += 1
        
        if let error = locationError {
            throw error
        }
        
        guard let result = locationResult else {
            throw WeatherError.locationUnavailable
        }
        
        return result
    }
    
    func requestPermission() async -> Bool {
        requestPermissionCallCount += 1
        return permissionResult
    }
}
