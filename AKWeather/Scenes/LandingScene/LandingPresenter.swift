//
//  MultipleCitiesPresenter.swift
//  AKWeather
//
//  Created by Atif Khan on 20/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import Foundation

protocol LandingPresentationLogic {
    func presentCities(queryString: String)
    func presentAlertView(message: String)
    func presentLoader()
    func hideLoader()
}

struct LandingPresenter : LandingPresentationLogic {
    weak var viewController : LandingDisplayable?
    
    func presentCities(queryString: String) {
        viewController?.displayCities(queryString: queryString)
    }
    
    func presentAlertView(message: String) {
        viewController?.displayAlertView(message: message)
    }
    
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
}
