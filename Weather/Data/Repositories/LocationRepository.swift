//
//  LocationRepository.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

import Foundation
import CoreLocation

final class LocationRepository: NSObject, LocationRepositoryProtocol {
    
    private let locationManager: CLLocationManager
        
    // Continuations to bridge delegate callbacks → async/await
    private var locationContinuation: CheckedContinuation<LocationEntity, Error>?
    private var permissionContinuation: CheckedContinuation<Bool, Never>?
        
    override init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer // City-level accuracy is sufficient
    }
    
    func getCurrentLocation() async throws -> LocationEntity {
        let status = locationManager.authorizationStatus
        guard status == .authorizedWhenInUse || status == .authorizedAlways else {
            throw WeatherError.locationDenied
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation = continuation
            self.locationManager.requestLocation()
        }
    }
    
    func requestPermission() async -> Bool {
        let status = locationManager.authorizationStatus
        
        // Already determined
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            return true
        }
        if status == .denied || status == .restricted {
            return false
        }
        
        // Not determined — request and wait for delegate callback
        return await withCheckedContinuation { continuation in
            self.permissionContinuation = continuation
            self.locationManager.requestWhenInUseAuthorization()
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension LocationRepository: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            locationContinuation?.resume(throwing: WeatherError.locationUnavailable)
            locationContinuation = nil
            return
        }
        
        let entity = LocationEntity(
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        locationContinuation?.resume(returning: entity)
        locationContinuation = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: WeatherError.locationUnavailable)
        locationContinuation = nil
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        // Only resume if we're actually waiting for permission
        guard let continuation = permissionContinuation else { return }
        
        let status = manager.authorizationStatus
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            continuation.resume(returning: true)
        case .denied, .restricted:
            continuation.resume(returning: false)
        case .notDetermined:
            return // Still waiting, don't resume yet
        @unknown default:
            continuation.resume(returning: false)
        }
        permissionContinuation = nil
    }
}
