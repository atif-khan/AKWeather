//
//  MultipleCitiesService.swift
//  AKWeather
//
//  Created by Atif Khan on 19/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import Foundation

final class MultipleCitiesService {
    
    private var client: HttpClient
    
    init(client: HttpClient = HttpClient()) {
        self.client = client
    }
    
    @discardableResult
    func loadWeatherFor(forCities citiesID: String, completion: @escaping (MultipleCities?, ServiceError?) -> ()) -> URLSessionDataTaskProtocol? {

        let params: JSON = ["id": citiesID, "units": "metric"]
        
        return client.load(path: "data/2.5/group", method: .get, params: params) { result, error in
            
            guard error == nil else {
                completion(nil, error!)
                return
            }
            
            if let data = result as? Data {
            
                let newJSONDecoder = JSONDecoder()
                
                do {
                    let json = try newJSONDecoder.decode(MultipleCities.self, from: data)
                    completion(json , error)
                } catch (let err) {
                    completion(nil, ServiceError.custom(err.localizedDescription))
                }
                
            }
        }
    }
}
