//
//  Constants.swift
//  WeatherApp
//
//  Created by Erick Manrique on 9/16/23.
//

import Foundation
import SwiftUI

enum OpenWeatherAPI {
    enum Data {
        case weather
        
        var baseUrl: String {
            return "https://api.openweathermap.org/data/2.5"
        }
        
        var path: String {
            switch self {
            case .weather:
                return "\(baseUrl)/weather"
            }
        }
    }
    
    enum Geo {
        case direct
        
        var baseUrl: String {
            return "https://api.openweathermap.org/geo/1.0"
        }
        
        var path: String {
            switch self {
            case .direct:
                return "\(baseUrl)/direct"
            }
        }
    }
}
