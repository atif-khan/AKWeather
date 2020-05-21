//
//  MultipleCities.swift
//  AKWeather
//
//  Created by Atif Khan on 19/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import Foundation

struct MultipleCitiesViewModel {
    
    struct MultipleCitiesResponse {
        let cities: MultipleCities
    }
    
    struct MultipleCitiesError: Error {
        var localizedDescription: String
    }
    
    struct ViewModel {
        let cities: MultipleCities
    }
    
}
