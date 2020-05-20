//
//  ForecastInteractor.swift
//  AKWeather
//
//  Created by Atif Khan on 19/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import Foundation
import CoreLocation

protocol ForecastBusinessLogic {
    func askPermissionForLocation()
}

protocol ForecastDataStore {
    var report: ForecastReport { get }
}

class ForecastInteractor : NSObject, ForecastBusinessLogic {
    
    private var locationManager: CLLocationManager!
    private var didGetLocalityName: Bool = false
    private var forecastWorker = ForecastWorker()
    
    var presenter: ForecastPresentationLogic?
    
    init(presenter: ForecastPresentationLogic) {
        self.presenter = presenter
    }
    
    func askPermissionForLocation() {
        askForAuthorization()
    }
}

extension ForecastInteractor: CLLocationManagerDelegate {
    
    func askForAuthorization() {
        
        locationManager = CLLocationManager()
        
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        locationManager.delegate = self
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("authorization failed")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.first {
            // convert this location into PlaceMark
            self.presenter?.presentLoader()
            convertLocationIntoPlaceMark(location: location)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func convertLocationIntoPlaceMark(location: CLLocation) {
        
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) in
            
            if error == nil {
                if !self.didGetLocalityName {
                    self.didGetLocalityName = true
                    if let firstLocation = placemarks?[0] {
                        self.getWeatherForCity(city: firstLocation.locality ?? "")
                    }
                }
            }
            else {
                // An error occurred during geocoding.
                print("Error while converting location into placemark.. Trying again")
                self.locationManager.requestLocation()
            }
        })
    }
}

extension ForecastInteractor {
    
    func getWeatherForCity(city: String) {
        
        forecastWorker.loadWeatherFor(city: city) { [weak self] (report, error) in
                   
            guard error == nil else {
                self?.presenter?.presentError(ForecastViewModel.ForecastError(localizedDescription: error!.localizedDescription))
                return
            }
            
            if let report = report {
                self?.presenter?.presentForecast(ForecastViewModel.Response(forecastReport: report))
            }else {
                self?.presenter?.presentError(ForecastViewModel.ForecastError(localizedDescription: "No data"))
            }
        }
    }
}
