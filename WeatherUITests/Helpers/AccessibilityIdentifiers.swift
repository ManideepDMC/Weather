//
//  AccessibilityIdentifiers.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import Foundation

/// Shared accessibility identifiers used by both Views and UI Tests.
/// Defined in one place to prevent mismatches.
enum AccessibilityID {
    
    // MARK: - Search
    static let searchTextField = "search_text_field"
    static let searchClearButton = "search_clear_button"
    static let searchResultsList = "search_results_list"
    static let searchLoadingIndicator = "search_loading_indicator"
    
    static func searchResultCell(index: Int) -> String {
        "search_result_cell_\(index)"
    }
    
    // MARK: - Weather Display
    static let weatherIcon = "weather_icon"
    static let cityNameLabel = "city_name_label"
    static let temperatureLabel = "temperature_label"
    static let descriptionLabel = "description_label"
    static let highTempLabel = "high_temp_label"
    static let lowTempLabel = "low_temp_label"
    
    // MARK: - Detail Cards
    static let feelsLikeCard = "feels_like_card"
    static let humidityCard = "humidity_card"
    static let windCard = "wind_card"
    static let visibilityCard = "visibility_card"
    static let pressureCard = "pressure_card"
    static let sunriseCard = "sunrise_card"
    static let sunsetCard = "sunset_card"
    static let seaLevelCard = "sea_level_card"
    static let groundLevelCard = "ground_level_card"
    
    // MARK: - States
    static let loadingView = "loading_view"
    static let errorView = "error_view"
    static let idleView = "idle_view"
    static let retryButton = "retry_button"
}
