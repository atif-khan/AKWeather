//
//  ForecastViewModel.swift
//  AKWeather
//
//  Created by Atif Khan on 19/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import Foundation

struct ForecastViewModel {
    
    struct Response {
        let forecastReport: ForecastReport
    }
    
    struct ForecastError: Error {
        var localizedDescription: String
    }
    
    struct HourlyViewModel {
        let temp: String
        let wind: String
        let time: String
        let icon: String
    }
    
    struct ViewModel {
        
        let date: String
        let avgWind: String
        let avgTempMin: String
        let avgTempMax: String
        let desc: String
        let icon: String
        
        let hourlyModel: [HourlyViewModel]
    }
    
    struct ViewModelArray {
        let viewModels : [ViewModel]
    }
}
