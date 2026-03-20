//
//  CacheRepositoryProtocol.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

protocol CacheRepositoryProtocol {
    func saveLastSearchedCity(_ city: CityEntity)
    func getLastSearchedCity() -> CityEntity?
}
