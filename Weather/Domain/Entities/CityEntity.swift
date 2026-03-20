//
//  CityEntity.swift
//  Weather
//
//  Created by Manideep on 19/03/26.
//

import Foundation

struct CityEntity: Codable {
    let name: String
    let state: String?    // only for US cities
    let country: String
    let latitude: Double
    let longitude: Double
}
