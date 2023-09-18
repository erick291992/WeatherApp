//
//  LocationCacheManager.swift
//  WeatherApp
//
//  Created by Erick Manrique on 9/17/23.
//

import Foundation

class LocationCacheManager {
    static let shared = LocationCacheManager()
    
    private let userDefaults = UserDefaults.standard
    private let locationKey = "cachedLocation"

    private init() { }
    
    func cacheLocation(_ location: Location) {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            if let data = try? JSONEncoder().encode(location) {
                userDefaults.set(data, forKey: self.locationKey)
            }
        }
    }
    
    func getCachedLocation() async -> Location? {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global().async { [weak self] in
                guard let self = self else { return }
                // Normally we try not to use userdefault and use an alternative way to read and write in a async way
                if let data = self.userDefaults.data(forKey: self.locationKey),
                   let cachedLocation = try? JSONDecoder().decode(Location.self, from: data) {
                    continuation.resume(returning: cachedLocation)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    func clearCache() {
        userDefaults.removeObject(forKey: locationKey)
    }
}
