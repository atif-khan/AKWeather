//
//  WeatherForecastVC.swift
//  AKWeather
//
//  Created by Atif Khan on 19/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import UIKit
import MBProgressHUD

class WeatherForecastVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var queryCities : String!
    var cityTask: URLSessionDataTaskProtocol!
    
    var cities : MultipleCities?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       getWeatherForCities(cities: queryCities)
    }

}

extension WeatherForecastVC {
    
    func getWeatherForCities(cities: String) {
        
        guard !cities.isEmpty else {
            return
        }
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        MultipleCitiesService.init().loadWeatherFor(forCities: cities) { (cities, error) in
                   
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            
            guard error == nil else {
                return
            }
            
            DispatchQueue.main.async {
                if let cities = cities, cities.list.count > 0 {
                    self.cities = cities
                    
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension WeatherForecastVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities?.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WeatherTableViewCell
        
        let model = cities?.list[indexPath.row]
        
        cell.lblName.text = model?.name
        cell.lblMin.text = "\(model?.main.tempMin ?? 0.0)" + "\u{00B0}C"
        cell.lblMax.text = "\(model?.main.tempMax ?? 0.0)" + "\u{00B0}C"
        cell.lblWind.text = "\(model?.wind.speed ?? 0.0)" + "m/s"
        cell.lblDesc.text = "\(model?.weather.first?.weatherDescription.capitalized ?? "")"
        
        return cell
    }
}

