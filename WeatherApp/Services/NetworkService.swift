//
//  NetworkService.swift
//  WeatherApp
//
//  Created by Erick Manrique on 9/16/23.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum NetworkError: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case invalidResponse
}

protocol NetworkServiceProtocol {
    func fetchData<T: Codable>(
        from urlString: String,
        method: HTTPMethod,
        body: Data?,
        bodyParams: [String: Any]?,
        queryParams: [String: String]?,
        headers: [String: String]?
    ) async throws -> T
}

extension NetworkServiceProtocol {
    func fetchData<T: Codable>(
        from urlString: String,
        method: HTTPMethod,
        body: Data?,
        bodyParams: [String: Any]?,
        queryParams: [String: String]?,
        headers: [String: String]?
    )
    async throws -> T {
        do {
            // Attempt to create a URL from the provided string
            guard let url = URL(string: urlString) else {
                throw NetworkError.invalidURL
            }
            
            // Construct the URL with query parameters if provided
            var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryParams?.map { key, value in
                URLQueryItem(name: key, value: value)
            }
            guard let finalURL = components?.url else {
                throw NetworkError.invalidURL
            }

            // Construct the request
            var request = URLRequest(url: finalURL)
            request.httpMethod = method.rawValue

            // Set request body if provided as Data
            if let body = body {
                request.httpBody = body
            }
            // Convert bodyParams to Data if provided
            else if let bodyParams = bodyParams {
                request.httpBody = try? JSONSerialization.data(withJSONObject: bodyParams)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }

            // Set custom headers
            headers?.forEach { key, value in
                request.setValue(value, forHTTPHeaderField: key)
            }

            // Perform the request
            let (data, response) = try await URLSession.shared.data(for: request)

            print("✅ \(request.url)")
            // Check the response status code
            guard let httpResponse = response as? HTTPURLResponse, (200..<300).contains(httpResponse.statusCode) else {
                throw NetworkError.invalidResponse
            }

            // Decode the response data
            let decoder = JSONDecoder()
            let result = try decoder.decode(T.self, from: data)
            return result
        } catch {
            throw error
        }
    }
}

class NetworkService: NetworkServiceProtocol {
    
    static let shared = NetworkService()
        
    func searchCity(with name: String) async throws -> [City] {
        let url = OpenWeatherAPI.Geo.direct.path
        
        let queryParams: [String: String] = [
            "appid": "bf69bcd30fa4a235865b66ef6d4eea38",
            "limit": "5",
            "q": name
        ]
        
        do {
            return try await fetchData(from: url, method: .get, body: nil, bodyParams: nil, queryParams: queryParams, headers: nil)
        } catch {
            // Handle the error here or rethrow it if needed
            print("❌ Request failure reason:", error)
            throw error
        }
    }
    
    
    func getWeather(for latitude: Double, longitude: Double) async throws -> WeatherData {
        let url = OpenWeatherAPI.Data.weather.path
        
        let queryParams: [String: String] = [
            "appid": "bf69bcd30fa4a235865b66ef6d4eea38",
            "lat": String(latitude),
            "lon": String(longitude),
            "units": "metric"
        ]
        
        do {
            return try await fetchData(from: url, method: .get, body: nil, bodyParams: nil, queryParams: queryParams, headers: nil)
        } catch {
            // Handle the error here or rethrow it if needed
            print("❌ Request failure reason:", error)
            throw error
        }
    }
}
