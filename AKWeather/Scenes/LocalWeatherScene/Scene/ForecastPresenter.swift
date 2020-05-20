//
//  ForecastPresenter.swift
//  AKWeather
//
//  Created by Atif Khan on 19/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import Foundation

protocol ForecastPresentationLogic {
    func presentForecast(_ response: ForecastViewModel.Response)
    func presentLoader()
    func presentError(_ response: ForecastViewModel.ForecastError)
}

struct ForecastPresenter : ForecastPresentationLogic {
    weak var viewController : ForecastDisplayable?
    
    func presentLoader() {
        DispatchQueue.main.async {
            self.viewController?.displayLoader()
        }
    }
    
    func presentError(_ response: ForecastViewModel.ForecastError) {
        DispatchQueue.main.async {
            self.viewController?.dislpayError(error: response.localizedDescription)
        }
    }
    
    func presentForecast(_ response: ForecastViewModel.Response) {
        
        let forecastReport = response.forecastReport
        let vm = prepareData(forecastReport)
        
        DispatchQueue.main.async {
            self.viewController?.displayForecast(viewModel: vm)
        }
        
    }

    func prepareData(_ forecastReport: ForecastReport) -> ForecastViewModel.ViewModelArray {

        var datesArray = [String]()

        // Days separated
        forecastReport.list.forEach { listItem in

            if let dateWithoutTime = listItem.dtTxt.components(separatedBy: " ").first, !datesArray.contains(dateWithoutTime) {
                datesArray.append(dateWithoutTime)
            }
        }

        var viewModel = [ForecastViewModel.ViewModel]()
        
        datesArray.forEach { (date) in
            // Now do the bindind of data with date
            
            var tempMinArray = [Double]()
            var tempMaxArray = [Double]()
            var tempWindArray = [Double]()
            
            var hourlyModel = [ForecastViewModel.HourlyViewModel]()
            var desc: String = ""
            var icon: String = ""
            
            forecastReport.list.forEach { listItem in

                if let dateWithoutTime = listItem.dtTxt.components(separatedBy: " ").first, dateWithoutTime == date {
                    
                    if desc.isEmpty {
                        desc = listItem.weather.first?.weatherDescription.desc ?? ""
                        icon = "https://openweathermap.org/img/wn/" + (listItem.weather.first?.icon ?? "") + ".png"
                    }
                    
                    tempMinArray.append(listItem.main.tempMin)
                    tempMaxArray.append(listItem.main.tempMax)
                    tempWindArray.append(listItem.wind.speed)
                    
                    var timeStr: String = ""
                    
                    if var time = listItem.dtTxt.components(separatedBy: " ").last {
                        
                        let startIndex = time.startIndex
                        let endIndex = time.endIndex
                        let indexOfColon = time.index(startIndex, offsetBy: 5)
                        time.removeSubrange(indexOfColon..<endIndex)
                        
                        timeStr = time
                    }
                    
                    hourlyModel.append(ForecastViewModel.HourlyViewModel(   temp: "\(listItem.main.temp)" + "\u{00B0}C",
                                                                            wind: "\(listItem.wind.speed)" + "m/s",
                                                                            time: timeStr,
                                                                            icon: "https://openweathermap.org/img/wn/" + (listItem.weather.first?.icon ?? "") + ".png"))
                }
            }
            
            let avgTempMin = "\(round((tempMinArray.reduce(0) { $0 + $1 }) / Double(tempMinArray.count)))" + "\u{00B0}C"
            let avgTempMax = "\(round((tempMaxArray.reduce(0) { $0 + $1 }) / Double(tempMaxArray.count)))" + "\u{00B0}C"
            let avgWind = "\(round((tempWindArray.reduce(0) { $0 + $1 }) / Double(tempWindArray.count)))" + "m/s"
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.date(from: date)
            
            dateFormatter.dateFormat = "dd MMM"
            
            let vm = ForecastViewModel.ViewModel(date: dateFormatter.string(from: date!), avgWind: avgWind, avgTempMin: avgTempMin, avgTempMax: avgTempMax, desc: desc, icon: icon, hourlyModel: hourlyModel)

            viewModel.append(vm)
        }

        return ForecastViewModel.ViewModelArray(viewModels: viewModel)
    }
}
