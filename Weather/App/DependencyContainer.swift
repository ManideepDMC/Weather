//
//  DependencyContainer.swift
//  Weather
//
//  Created by Manideep on 20/03/26.
//

import Foundation

// MARK: - Skip Location Use Case (UI Testing)
/// A location use case that always denies permission.
/// Used during UI testing to skip the system location prompt.
final class SkipLocationUseCase: GetCurrentLocationUseCaseProtocol {
    func getCurrentLocation() async throws -> LocationEntity {
        throw WeatherError.locationDenied
    }

    func requestPermission() async -> Bool {
        return false
    }
}

/// Assembles all dependencies and provides them via protocols.
/// Created once at app launch and passed through coordinators.
final class DependencyContainer {

    // MARK: - Overrides (for testing)
    var overrideLocationUseCase: GetCurrentLocationUseCaseProtocol?

    // MARK: - Network
    lazy var networkService: NetworkServiceProtocol = {
        NetworkService()
    }()
    
    // MARK: - Repositories
    lazy var weatherRepository: WeatherRepositoryProtocol = {
        WeatherRepository(networkService: networkService)
    }()
    
    lazy var locationRepository: LocationRepositoryProtocol = {
        LocationRepository()
    }()
    
    lazy var cacheRepository: CacheRepositoryProtocol = {
        CacheRepository()
    }()
    
    // MARK: - Services
    lazy var imageCacheService: ImageCacheServiceProtocol = {
        ImageCacheService(networkService: networkService)
    }()
    
    // MARK: - Use Cases
    func makeFetchWeatherUseCase() -> FetchWeatherUseCaseProtocol {
        FetchWeatherUseCase(weatherRepository: weatherRepository)
    }
    
    func makeSearchCityUseCase() -> SearchCityUseCaseProtocol {
        SearchCityUseCase(weatherRepository: weatherRepository)
    }
    
    func makeGetLastSearchedCityUseCase() -> GetLastSearchedCityUseCaseProtocol {
        GetLastSearchedCityUseCase(cacheRepository: cacheRepository)
    }
    
    func makeGetCurrentLocationUseCase() -> GetCurrentLocationUseCaseProtocol {
        GetCurrentLocationUseCase(locationRepository: locationRepository)
    }
    
    // MARK: - ViewModel Factory
    func makeWeatherViewModel() -> WeatherViewModel {
        WeatherViewModel(
            fetchWeatherUseCase: makeFetchWeatherUseCase(),
            searchCityUseCase: makeSearchCityUseCase(),
            lastSearchedCityUseCase: makeGetLastSearchedCityUseCase(),
            currentLocationUseCase: overrideLocationUseCase ?? makeGetCurrentLocationUseCase(),
            imageCacheService: imageCacheService
        )
    }
}
