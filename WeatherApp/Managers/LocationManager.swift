//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Erick Manrique on 9/16/23.
//

import Foundation
import CoreLocation
import Combine

protocol LocationManagerDelegate: AnyObject {
    func didUpdateLocation(_ location: Location)
    func didChangePermissionStatus(_ status: LocationPermissionStatus)
    func didEncounterError(_ error: LocationError)
}

struct Location: Codable {
    let latitude: Double
    let longitude: Double
}

enum LocationPermissionStatus {
    case notDetermined
    case authorized
    case denied
    case disabled
    case unknown
    case fetchFailed
}

enum LocationError: Error {
    case fetchFailed
}

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    private let locationManager = CLLocationManager()
    weak var delegate: LocationManagerDelegate?
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func checkLocationPermission() {
        // TODO: check locationServicesEnabled() when user turned off location in the system settings
        switch locationManager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            delegate?.didChangePermissionStatus(.authorized)
        case .notDetermined:
            delegate?.didChangePermissionStatus(.notDetermined)
        case .denied, .restricted:
            delegate?.didChangePermissionStatus(.denied)
        default:
            delegate?.didChangePermissionStatus(.unknown)
        }
    }
    
    func requestWhenInUsePermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func fetchLocation() {
        locationManager.requestLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last?.coordinate {
            delegate?.didUpdateLocation(Location(latitude: location.latitude, longitude: location.longitude))
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.didEncounterError(.fetchFailed)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            delegate?.didChangePermissionStatus(.authorized)
        case .denied, .restricted:
            delegate?.didChangePermissionStatus(.denied)
        default:
            break
        }
    }
}
