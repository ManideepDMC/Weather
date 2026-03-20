//
//  GetCurrentLocationUseCaseProtocol.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

import Foundation

protocol GetCurrentLocationUseCaseProtocol {
    func getCurrentLocation() async throws -> LocationEntity
    func requestPermission() async -> Bool
}

final class GetCurrentLocationUseCase: GetCurrentLocationUseCaseProtocol {
    private let locationRepository: LocationRepositoryProtocol
    
    init(locationRepository: LocationRepositoryProtocol) {
        self.locationRepository = locationRepository
    }
    
    func getCurrentLocation() async throws -> LocationEntity {
        try await locationRepository.getCurrentLocation()
    }
    
    func requestPermission() async -> Bool {
        await locationRepository.requestPermission()
    }
}
