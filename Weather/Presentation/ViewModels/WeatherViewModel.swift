//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import Foundation
import Combine

// MARK: - View State
/// Represents every possible state the weather screen can be in.
/// The View switches on this to decide what to render.
enum WeatherViewState: Equatable {
    case idle
    case loading
    case loaded(WeatherEntity)
    case error(String)
    
    // Equatable conformance for state comparison
    static func == (lhs: WeatherViewState, rhs: WeatherViewState) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.loading, .loading):
            return true
        case (.loaded(let a), .loaded(let b)):
            return a.cityName == b.cityName
        case (.error(let a), .error(let b)):
            return a == b
        default:
            return false
        }
    }
}

// MARK: - ViewModel
final class WeatherViewModel: ObservableObject {
    
    // MARK: - Published Properties (observed by SwiftUI Views)
    @Published var viewState: WeatherViewState = .idle
    @Published var searchText: String = ""
    @Published var weatherIconData: Data?
    @Published var searchResults: [CityEntity] = []
    @Published var isSearching: Bool = false
    
    // MARK: - Dependencies
    private let fetchWeatherUseCase: FetchWeatherUseCaseProtocol
    private let searchCityUseCase: SearchCityUseCaseProtocol
    private let lastSearchedCityUseCase: GetLastSearchedCityUseCaseProtocol
    private let currentLocationUseCase: GetCurrentLocationUseCaseProtocol
    private let imageCacheService: ImageCacheServiceProtocol
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(
        fetchWeatherUseCase: FetchWeatherUseCaseProtocol,
        searchCityUseCase: SearchCityUseCaseProtocol,
        lastSearchedCityUseCase: GetLastSearchedCityUseCaseProtocol,
        currentLocationUseCase: GetCurrentLocationUseCaseProtocol,
        imageCacheService: ImageCacheServiceProtocol
    ) {
        self.fetchWeatherUseCase = fetchWeatherUseCase
        self.searchCityUseCase = searchCityUseCase
        self.lastSearchedCityUseCase = lastSearchedCityUseCase
        self.currentLocationUseCase = currentLocationUseCase
        self.imageCacheService = imageCacheService
        
        setupSearchDebounce()
    }
    
    // MARK: - App Launch Flow
    /// Called once when the view appears.
    /// Priority: last searched city → user location → empty state
    func onAppear() {
        // 1. Try loading last searched city
        if let lastCity = lastSearchedCityUseCase.getLastSearchedCity() {
            searchText = lastCity.name
            fetchWeather(latitude: lastCity.latitude, longitude: lastCity.longitude)
            return
        }
        
        // 2. No cached city — request location
        requestLocationAndFetchWeather()
    }
    
    // MARK: - City Selection (user tapped a search result)
    func selectCity(_ city: CityEntity) {
        searchText = city.name
        searchResults = []
        isSearching = false
        
        // Save as last searched
        lastSearchedCityUseCase.saveLastSearchedCity(city)
        
        // Fetch weather for selected city
        fetchWeather(latitude: city.latitude, longitude: city.longitude)
    }
    
    // MARK: - Location
    func requestLocationAndFetchWeather() {
        Task { @MainActor in
            let granted = await currentLocationUseCase.requestPermission()
            
            guard granted else {
                // User denied — stay on idle, they can search manually
                if case .idle = viewState {
                    // Only set idle if we haven't loaded anything yet
                }
                return
            }
            
            do {
                viewState = .loading
                let location = try await currentLocationUseCase.getCurrentLocation()
                fetchWeather(latitude: location.latitude, longitude: location.longitude)
            } catch {
                viewState = .error(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Search Debounce
    /// Waits 500ms after the user stops typing before firing the search.
    /// Prevents hammering the API on every keystroke.
    private func setupSearchDebounce() {
        $searchText
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] query in
                guard let self = self else { return }
                let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
                if trimmed.count >= 2 {
                    self.searchCity(query: trimmed)
                } else {
                    self.searchResults = []
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Private: Search City
    private func searchCity(query: String) {
        Task { @MainActor in
            isSearching = true
            do {
                let results = try await searchCityUseCase.searchCity(query: query)
                self.searchResults = results
            } catch {
                // Search errors are non-fatal — just clear results
                // Given more time, we could show inline search error
                self.searchResults = []
            }
            isSearching = false
        }
    }
    
    // MARK: - Private: Fetch Weather
    private func fetchWeather(latitude: Double, longitude: Double) {
        Task { @MainActor in
            viewState = .loading
            weatherIconData = nil
            
            do {
                let weather = try await fetchWeatherUseCase.fetchWeather(
                    latitude: latitude,
                    longitude: longitude
                )
                viewState = .loaded(weather)
                
                // Load icon separately — weather data shows immediately,
                // icon loads in background without blocking
                await loadWeatherIcon(code: weather.iconCode)
            } catch let error as WeatherError {
                viewState = .error(error.localizedDescription)
            } catch {
                viewState = .error(WeatherError.unknown.localizedDescription)
            }
        }
    }
    
    // MARK: - Private: Load Icon
    private func loadWeatherIcon(code: String) async {
        do {
            let data = try await imageCacheService.loadImage(for: code)
            self.weatherIconData = data
        } catch {
            // Icon failure is non-fatal — weather data still shows
            // Given more time, we'd set a fallback SF Symbol here
            self.weatherIconData = nil
        }
    }
}

// MARK: - Display Helpers
/// Formatting logic lives in ViewModel, not in View.
/// Views only call these — they never do calculations.
extension WeatherViewModel {
    
    func formattedTemperature(_ temp: Double) -> String {
        "\(Int(round(temp)))°F"
    }
    
    func formattedDescription(_ description: String) -> String {
        description.capitalized
    }
    
    func formattedWindSpeed(_ speed: Double) -> String {
        String(format: "%.1f mph", speed)
    }
    
    func formattedVisibility(_ meters: Int) -> String {
        let miles = Double(meters) / 1609.34
        return String(format: "%.1f mi", miles)
    }
    
    func formattedTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
