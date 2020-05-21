//
//  MultipleCitiesVC.swift
//  AKWeather
//
//  Created by Atif Khan on 19/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol MultipleCitiesDisplayable: class {
    func displayForecast(viewModel: MultipleCitiesViewModel.ViewModel)
    func displayLoader()
    func hideLoader()
}

class MultipleCitiesVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var queryCities : String!
    var viewModel : MultipleCitiesViewModel.ViewModel?
    var interactor: MultipleCitiesInteractor? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let presenter = MultipleCitiesPresenter(viewController: self)
        interactor = MultipleCitiesInteractor(presenter: presenter)
        interactor?.getWeatherForCities(cities: queryCities)
    }

}


extension MultipleCitiesVC : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.cities.list.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! WeatherTableViewCell
        
        let model = viewModel?.cities.list[indexPath.row]
        
        cell.lblName.text = model?.name
        cell.lblMin.text = "\(model?.main.tempMin ?? 0.0)" + "\u{00B0}C"
        cell.lblMax.text = "\(model?.main.tempMax ?? 0.0)" + "\u{00B0}C"
        cell.lblWind.text = "\(model?.wind.speed ?? 0.0)" + "m/s"
        cell.lblDesc.text = "\(model?.weather.first?.weatherDescription.capitalized ?? "")"
        
        return cell
    }
}

extension MultipleCitiesVC: MultipleCitiesDisplayable {
    
    func displayForecast(viewModel: MultipleCitiesViewModel.ViewModel) {
        self.viewModel = viewModel
        self.tableView.reloadData()
    }
    
    func displayLoader() {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    
    func hideLoader() {
        MBProgressHUD.hide(for: self.view, animated: true)
    }
    
}
