//
//  LandingViewController.swift
//  AKWeather
//
//  Created by Atif Khan on 19/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import UIKit

protocol LandingDisplayable: class {
    func displayCities(queryString: String)
    func displayAlertView(message: String)
    func displayLoader()
    func hideLoader()
}


class LandingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtFieldCities: UITextField!
    @IBOutlet weak var btnCheckWeather: UIButton!

    private var queryString: String?
    var interactor: LandingInteractor?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let presenter = LandingPresenter(viewController: self)
        interactor = LandingInteractor(presenter: presenter)
    }

    @IBAction func btnCheckWeatherTapped(_ sender: UIButton) {
        interactor?.getCitiesFromJSON(cityNames: txtFieldCities.text ?? "", completion: {_ in })

    }
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            // Show Alert
            let alertVc = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))

            self.present(alertVc, animated: true)
        }
    }
    
    
    //MARK: - UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToWeather" {
            let destination = segue.destination as! MultipleCitiesVC
            destination.queryCities = queryString
        }
    }
}

extension LandingViewController: LandingDisplayable {
    func displayCities(queryString: String) {
        self.queryString = queryString
        self.performSegue(withIdentifier: "segueToWeather", sender: nil)
    }
    
    func displayAlertView(message: String) {
        showAlert(message: message)
    }
    
    func displayLoader() {
        
    }
    
    func hideLoader() {
        
    }
}

