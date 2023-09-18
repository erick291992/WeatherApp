//
//  HomeViewModel.swift
//  WeatherApp
//
//  Created by Erick Manrique on 9/16/23.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    private let locationManager = LocationManager()
    private var lastSearchedLocation: Location? = nil
    private var didCallCache = false
    @Published private(set) var locationPermission: LocationPermissionStatus = .notDetermined
    @Published private(set) var weatherData: WeatherData?
    @Published var isPresentingSearchView: Bool = false
    
    @Published var errorMessage: String = ""
    @Published var showError: Bool = false
    
    init() {
        
        
        locationManager.delegate = self
        locationManager.checkLocationPermission()
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUsePermission()
    }
    
    func onUserLocationSearched(location: Location) {
        LocationCacheManager.shared.cacheLocation(location)
        fetchWeather(from: location)
    }
    
    private func fetchWeather(from location: Location) {
        Task {
            do {
                let weather = try await NetworkService.shared.getWeather(for: location.latitude, longitude: location.longitude)
                await MainActor.run(body: {
                    self.weatherData = weather
                })
            } catch {
                await setError(error)
            }
        }
    }
    
    func fetchCacheLocation() {
        if didCallCache {
            return
        }
        Task { [weak self] in
            guard let self = self else { return }
            if let cachedLocation = await LocationCacheManager.shared.getCachedLocation() {
                await MainActor.run(body: { [weak self] in
                    guard let self = self else { return }
                    self.didCallCache = true
                    self.lastSearchedLocation = cachedLocation
                    // Only fetch weather with last searched location if we dont have weather data
                    // since we may already have weather data from current location
                    if self.weatherData == nil {
                        self.fetchWeather(from: cachedLocation)
                    }
                })
            } else {
                // TODO: handle errors
                self.didCallCache = true
            }
        }
    }
    
    func setError(_ error: Error) async {
        // MARK: UI Must be run on the Main Thread
        await MainActor.run(body: {
            errorMessage = error.localizedDescription
            showError.toggle()
        })
    }
}

extension HomeViewModel: LocationManagerDelegate {
    func didUpdateLocation(_ location: Location) {
        fetchWeather(from: location)
    }
    
    func didChangePermissionStatus(_ status: LocationPermissionStatus) {
        self.locationPermission = status
        if status == .authorized {
            locationManager.fetchLocation()
        } else {
            fetchCacheLocation()
        }
    }
    
    func didEncounterError(_ error: LocationError) {
        Task {
            await setError(error)
        }
    }
}
