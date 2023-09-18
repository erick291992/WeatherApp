//
//  Double+Extensions.swift
//  WeatherApp
//
//  Created by Erick Manrique on 9/16/23.
//

import Foundation

extension Double {
    func roundedString(decimalPlaces: Int = 0) -> String {
        let format = String(format: "%%.%df", decimalPlaces)
        return String(format: format, self)
    }
}
