//
//  MultipleCitiesInteractor.swift
//  AKWeather
//
//  Created by Atif Khan on 20/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import Foundation

protocol MultipleCitiesBusinessLogic {
    func getWeatherForCities(cities: String)
}

protocol MultipleCitiesDataStore {
    var cities: MultipleCities? { get }
}

class MultipleCitiesInteractor : NSObject, MultipleCitiesBusinessLogic, MultipleCitiesDataStore {
    var cities: MultipleCities?
    
    private var worker = MultipleCitiesWorker()
    var presenter: MultipleCitiesPresentationLogic?
    
    init(presenter: MultipleCitiesPresentationLogic) {
        self.presenter = presenter
    }
}


extension MultipleCitiesInteractor {
    func getWeatherForCities(cities: String) {
        guard !cities.isEmpty else {
            return
        }
        
        presenter?.presentLoader()
        MultipleCitiesWorker.init().loadWeatherFor(forCities: cities) { (cities, error) in
                   
            self.presenter?.hideLoader()
            
            guard error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                if let cities = cities, cities.list.count > 0 {
                    self.cities = cities
                    let response = MultipleCitiesViewModel.MultipleCitiesResponse(cities: cities)
                    self.presenter?.presentForecast(response)
                }
            }
        }
    }
}
