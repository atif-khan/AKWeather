//
//  MultipleCitiesPresenter.swift
//  AKWeather
//
//  Created by Atif Khan on 20/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import Foundation

protocol MultipleCitiesPresentationLogic {
    func presentForecast(_ response: MultipleCitiesViewModel.MultipleCitiesResponse)
    func presentLoader()
    func hideLoader()
}

struct MultipleCitiesPresenter : MultipleCitiesPresentationLogic {
    
    weak var viewController : MultipleCitiesDisplayable?
    
    func presentLoader() {
        DispatchQueue.main.async {
            self.viewController?.displayLoader()
        }
    }
    
    func hideLoader() {
        DispatchQueue.main.async {
            self.viewController?.hideLoader()
        }
    }
    
    func presentForecast(_ response: MultipleCitiesViewModel.MultipleCitiesResponse) {
        let viewModel = MultipleCitiesViewModel.ViewModel(cities: response.cities)
        self.viewController?.displayForecast(viewModel: viewModel)
    }
}
