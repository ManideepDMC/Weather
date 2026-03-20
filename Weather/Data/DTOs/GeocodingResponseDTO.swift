//
//  GeocodingResponseDTO.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

import Foundation

struct GeocodingResponseDTO: Decodable {
    let name: String
    let state: String?
    let country: String
    let lat: Double
    let lon: Double
}

// MARK: - Mapping DTO → Domain Entity
extension GeocodingResponseDTO {
    func toDomain() -> CityEntity {
        CityEntity(
            name: name,
            state: state,
            country: country,
            latitude: lat,
            longitude: lon
        )
    }
}
