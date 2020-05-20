//
//  WeatherForecast.swift
//  AKWeather
//
//  Created by Atif Khan on 19/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import Foundation

// MARK: - ForecastReport
struct ForecastReport: Codable {
    let cod: String
    let message, cnt: Int
    let list: [ForecastList]
}


// MARK: - ForecastList
struct ForecastList: Codable {
    let dt: Int
    let main: ForecastMainClass
    let weather: [ForecastWeather]
    let wind: ForecastWind
    let dtTxt: String

    enum CodingKeys: String, CodingKey {
        case dt, main, weather, wind
        case dtTxt = "dt_txt"
    }
}

// MARK: - ForecastMainClass
struct ForecastMainClass: Codable {
    let temp, tempMin, tempMax: Double
    let pressure, seaLevel, grndLevel, humidity: Int
    let tempKf: Double

    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity
        case tempKf = "temp_kf"
    }
}

// MARK: - ForecastWeather
struct ForecastWeather: Codable {
    let id: Int
    let main: ForecastMainEnum
    let weatherDescription: ForecastDescription
    let icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
}

enum ForecastMainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

enum ForecastDescription: String, Codable {
    case brokenClouds = "broken clouds"
    case clearSky = "clear sky"
    case fewClouds = "few clouds"
    case lightRain = "light rain"
    case overcastClouds = "overcast clouds"
    case scatteredClouds = "scattered clouds"
    
    var desc : String {
        return rawValue
    }
}

// MARK: - ForecastWind
struct ForecastWind: Codable {
    let speed: Double
    let deg: Int
}
