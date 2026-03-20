//
//  CacheRepository.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

import Foundation

final class CacheRepository: CacheRepositoryProtocol {
    
    private let userDefaults: UserDefaults
    
    private enum Keys {
        static let lastCityName = "lastSearchedCityName"
        static let lastCityState = "lastSearchedCityState"
        static let lastCityCountry = "lastSearchedCityCountry"
        static let lastCityLatitude = "lastSearchedCityLatitude"
        static let lastCityLongitude = "lastSearchedCityLongitude"
    }
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }
    
    func saveLastSearchedCity(_ city: CityEntity) {
        userDefaults.set(city.name, forKey: Keys.lastCityName)
        userDefaults.set(city.state, forKey: Keys.lastCityState)
        userDefaults.set(city.country, forKey: Keys.lastCityCountry)
        userDefaults.set(city.latitude, forKey: Keys.lastCityLatitude)
        userDefaults.set(city.longitude, forKey: Keys.lastCityLongitude)
    }
    
    func getLastSearchedCity() -> CityEntity? {
        guard let name = userDefaults.string(forKey: Keys.lastCityName),
              let country = userDefaults.string(forKey: Keys.lastCityCountry) else {
            return nil // No city saved yet (first launch)
        }
        
        let state = userDefaults.string(forKey: Keys.lastCityState)
        let latitude = userDefaults.double(forKey: Keys.lastCityLatitude)
        let longitude = userDefaults.double(forKey: Keys.lastCityLongitude)
        
        // Defensive: if coordinates are 0,0, something went wrong
        guard latitude != 0.0 || longitude != 0.0 else {
            return nil
        }
        
        return CityEntity(
            name: name,
            state: state,
            country: country,
            latitude: latitude,
            longitude: longitude
        )
    }
}
