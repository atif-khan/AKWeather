//
//  LandingViewController.swift
//  AKWeather
//
//  Created by Atif Khan on 19/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var txtFieldCities: UITextField!
    @IBOutlet weak var btnCheckWeather: UIButton!

    private var queryString: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func btnCheckWeatherTapped(_ sender: UIButton) {

        let strArray = txtFieldCities.text?.components(separatedBy: ",")

        self.getCitiesFromJSON(strArray: strArray) { (success, cityIds) in

            guard success else {
                self.showAlert(message: "Number of cities should be between 3 and 7")
                return
            }

            self.queryString = cityIds
            if cityIds == "" {
                self.showAlert(message: "Cities not found")
            } else {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "segueToWeather", sender: nil)
                }
            }
        }

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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueToWeather" {
            let destination = segue.destination as! WeatherForecastVC
            destination.queryCities = queryString
        }
    }

}

extension LandingViewController {

    func getCitiesFromJSON(strArray: [String]?, completion: @escaping (Bool, String?) -> Void) {

        if !self.validateString(array: strArray) {
            completion(false, nil)
            return
        }

        DispatchQueue.global().async {

            let json = self.readFromFile()

            let trimmedArray: [String]? = strArray?.map { $0.trim() }

            var cityIds = [String]()

            trimmedArray?.forEach({ (cityTxt) in

                if let filteredJSON = json?.first(where: { ($0["name"] as! String).lowercased() == cityTxt.lowercased() }) {
                    cityIds.append("\(filteredJSON["id"] ?? "")")
                }
            })

            completion(true, cityIds.joined(separator: ","))
        }
    }

    func validateString(array: [String]?) -> Bool {

        guard let array = array else {
            return false
        }

        guard array.count >= 3 && array.count <= 7 else {
            return false
        }

        return true
    }
}

extension String
{
    func trim() -> String
   {
    return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
   }
}

// File Read
extension LandingViewController {

    func readFromFile() -> [[String: Any]]? {

        let path = Bundle.main.path(forResource: "city.list", ofType: "json", inDirectory: nil, forLocalization: nil)
        let fileManager = FileManager()

        var json: [[String: Any]]? = nil

        if fileManager.fileExists(atPath: path!) {

            do {
                let data = try Data.init(contentsOf: URL(fileURLWithPath: path!))
                json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [[String: Any]]
            }catch(let err) {
                print("cant open file Error: \(err)")
            }
        }

        return json
    }
}
