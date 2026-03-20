//
//  LocationRepositoryProtocol.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

protocol LocationRepositoryProtocol {
    func getCurrentLocation() async throws -> LocationEntity
    func requestPermission() async -> Bool
}
