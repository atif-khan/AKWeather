//
//  FiveDayForecastVC.swift
//  AKWeather
//
//  Created by Atif Khan on 19/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import UIKit
import MBProgressHUD

protocol ForecastDisplayable: class {
    func displayForecast(viewModel: ForecastViewModel.ViewModelArray)
    func displayLoader()
    func dislpayError(error: String)
}

class FiveDayForecastVC: UIViewController {
 
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var lblHeader: UILabel!
    
    var foreCastReport: ForecastReport? = nil
    
    var viewModel: ForecastViewModel.ViewModelArray?
    
    var interactor: ForecastInteractor? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lblHeader.isHidden = true
        let presenter = ForecastPresenter(viewController: self)
        interactor = ForecastInteractor(presenter: presenter)
        
        interactor?.askPermissionForLocation()
    }
}

extension FiveDayForecastVC : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.viewModels.first?.hourlyModel.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "topCell", for: indexPath) as! HeaderCollectionViewCell
        
        let forecast = viewModel!.viewModels.first!.hourlyModel[indexPath.row]
        
        cell.lblTemp.text = forecast.temp
        cell.lblWind.text = forecast.wind
        cell.lblTime.text = forecast.time
        cell.imgView.image = UIImage(data: try! Data(contentsOf: URL(string: forecast.icon)!))
        return cell
    }
}

extension FiveDayForecastVC : UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        lblHeader.isHidden = viewModel?.viewModels.count ?? 0 == 0
        return viewModel?.viewModels.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ForecastTopCell
        
        let cast = viewModel!.viewModels[indexPath.row]
        
        cell.lblMIn.text = cast.avgTempMin
        cell.lblMax.text = cast.avgTempMax
        cell.lblWind.text = cast.avgWind
        cell.lblDesc.text = cast.desc
        cell.lblDate.text = cast.date
        cell.imgView.image = UIImage(data: try! Data(contentsOf: URL(string: cast.icon)!))
        return cell
    }
}

extension FiveDayForecastVC : ForecastDisplayable {
    
    func displayLoader() {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.hide(animated: true, afterDelay: 60)
    }
    
    func dislpayError(error: String) {
        
        MBProgressHUD.hide(for: self.view, animated: true)
        
        let alertVC = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func displayForecast(viewModel: ForecastViewModel.ViewModelArray) {
        
        MBProgressHUD.hide(for: self.view, animated: true)
        
        self.viewModel = viewModel
        
        self.tableView.reloadData()
        self.collectionView.reloadData()
    }
}
