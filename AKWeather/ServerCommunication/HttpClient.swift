//
//  HttpClient.swift
//  AKWeather
//
//  Created by Atif Khan on 19/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import Foundation

typealias JSON = [String: Any]

enum ServiceError: Error {
    case noInternetConnection
    case custom(String)
    case other
}

extension ServiceError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noInternetConnection:
            return "No Internet connection"
        case .other:
            return "Something went wrong"
        case .custom(let message):
            return message
        }
    }
}

extension ServiceError {
    init(json: JSON) {
        if let message =  json["message"] as? String {
            self = .custom(message)
        } else {
            self = .other
        }
    }
}

enum RequestMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

extension URL {
    init(baseUrl: String, path: String, params: JSON, method: RequestMethod) {
        var components = URLComponents(string: baseUrl)!
        components.path += path
        
        switch method {
        case .get, .delete:
            components.queryItems = params.map {
                URLQueryItem(name: $0.key, value: String(describing: $0.value))
            }
        default:
            break
        }
        
        self = components.url!
    }
}

extension URLRequest {
    
    init(baseUrl: String, path: String, method: RequestMethod, params: JSON) {
        
        let url = URL(baseUrl: baseUrl, path: path, params: params, method: method)
        self.init(url: url)
        
        httpMethod = method.rawValue
        setValue("application/json", forHTTPHeaderField: "Accept")
        setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        switch method {
        case .post, .put:
            httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
        default:
            break
        }
    }
}

// Protocol for MOCK/Real
protocol URLSessionProtocol {
    typealias DataTaskResult = (Data?, URLResponse?, Error?) -> Void
    
    func dataTask(with request: URLRequest, completionHandler: @escaping DataTaskResult) -> URLSessionDataTaskProtocol
}

protocol URLSessionDataTaskProtocol {
    func resume()
}

final class HttpClient {
    
    private var baseUrl: String
    private let session: URLSessionProtocol
    
    init(baseUrl: String, session: URLSessionProtocol = URLSession.shared) {
        self.baseUrl = baseUrl
        self.session = session
    }
    
    init(session: URLSessionProtocol = URLSession.shared) {
        self.baseUrl = "https://api.openweathermap.org/"
        self.session = session
    }
    
    @discardableResult
    func load(path: String, method: RequestMethod, params: JSON, completion: @escaping (Any?, ServiceError?) -> ()) -> URLSessionDataTaskProtocol? {
        
            // Checking internet connection availability
          if !Reachability.isConnectedToNetwork() {
                completion(nil, ServiceError.noInternetConnection)
                return nil
            }

            // Adding common parameters
            var parameters = params
            parameters["appid"] = OpenWeatherAPIKey

            // Creating the URLRequest object
            let request = URLRequest(baseUrl: baseUrl, path: path, method: method, params: parameters)

            // Sending request to the server.
            let task = session.dataTask(with: request) { data, response, error in
                // Parsing incoming data
                var object: Any? = nil
                if let data = data {
                    object = try? JSONSerialization.jsonObject(with: data, options: [])
                }
                
                if let httpResponse = response as? HTTPURLResponse, (200..<300) ~= httpResponse.statusCode {
                    completion(data, nil)
                } else {
                    let error = (object as? JSON).flatMap(ServiceError.init) ?? ServiceError.other
                    completion(nil, error)
                }
            }
            
            task.resume()
            
            return task
    }
}

//MARK: Conform the protocol
extension URLSession: URLSessionProtocol {
    func dataTask(with request: URLRequest, completionHandler: @escaping URLSessionProtocol.DataTaskResult) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTask
    }
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

