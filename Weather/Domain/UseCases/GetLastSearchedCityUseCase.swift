//
//  GetLastSearchedCityUseCase.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

import Foundation

protocol GetLastSearchedCityUseCaseProtocol {
    func getLastSearchedCity() -> CityEntity?
    func saveLastSearchedCity(_ city: CityEntity)
}

final class GetLastSearchedCityUseCase: GetLastSearchedCityUseCaseProtocol {
    private let cacheRepository: CacheRepositoryProtocol
    
    init(cacheRepository: CacheRepositoryProtocol) {
        self.cacheRepository = cacheRepository
    }
    
    func getLastSearchedCity() -> CityEntity? {
        cacheRepository.getLastSearchedCity()
    }
    
    func saveLastSearchedCity(_ city: CityEntity) {
        cacheRepository.saveLastSearchedCity(city)
    }
    
}
