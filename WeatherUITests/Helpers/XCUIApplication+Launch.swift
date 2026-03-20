//
//  XCUIApplication+Launch.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import XCTest

extension XCUIApplication {
    
    /// Standard launch with no special configuration.
    /// Used for tests that exercise the normal app flow.
    func launchForTesting() {
        launchArguments = ["-uitesting"]
        // Reset UserDefaults to ensure clean state
        launchArguments.append("-resetCache")
        launch()
    }
    
    /// Launch with a pre-set cached city.
    /// Simulates reopening the app after a previous search.
    func launchWithCachedCity(_ cityName: String, latitude: String, longitude: String, country: String = "US", state: String = "") {
        launchArguments = ["-uitesting", "-resetCache", "-skipLocation"]
        launchArguments.append(contentsOf: [
            "-cachedCityName", cityName,
            "-cachedCityLatitude", latitude,
            "-cachedCityLongitude", longitude,
            "-cachedCityCountry", country,
            "-cachedCityState", state
        ])
        launch()
    }
    
    /// Launch skipping the location permission prompt.
    /// Used when testing search flow without location interruption.
    func launchSkippingLocation() {
        launchArguments = ["-uitesting", "-resetCache", "-skipLocation"]
        launch()
    }
}
