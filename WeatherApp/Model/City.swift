//
//  City.swift
//  WeatherApp
//
//  Created by Erick Manrique on 9/16/23.
//

import Foundation

struct City: Codable, Identifiable {
    let id = UUID()
    let name: String
    let localNames: [String: String]?
    let latitude: Double
    let longitude: Double
    let country: String
    let state: String?

    enum CodingKeys: String, CodingKey {
        case name
        case localNames = "local_names"
        case latitude = "lat"
        case longitude = "lon"
        case country
        case state
    }
}
