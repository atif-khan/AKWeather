//
//  MultipleCitiesInteractor.swift
//  AKWeather
//
//  Created by Atif Khan on 20/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import Foundation

protocol LandingBusinessLogic {
    func getCitiesFromJSON(cityNames: String,  completion:@escaping ((Bool)->()))
}

class LandingInteractor : NSObject {
    var presenter: LandingPresentationLogic?
    
    init(presenter: LandingPresentationLogic) {
        self.presenter = presenter
    }
}

extension LandingInteractor: LandingBusinessLogic {
    func getCitiesFromJSON(cityNames: String,  completion:@escaping ((Bool) -> ())) {
         let strArray = cityNames.components(separatedBy: ",")
         if !self.validateString(array: strArray) {
             presenter?.presentAlertView(message: "Number of cities should be between 3 and 7")
                return
            }
        DispatchQueue.global().async {
            let json = self.readFromFile()
            let trimmedArray: [String]? = strArray.map { $0.trim() }
            var cityIds = [String]()
            trimmedArray?.forEach({ (cityTxt) in
                if let filteredJSON = json?.first(where: { ($0["name"] as! String).lowercased() == cityTxt.lowercased() }) {
                    cityIds.append("\(filteredJSON["id"] ?? "")")
                }
            })
         
         let queryString = cityIds.joined(separator: ",")
         if queryString == "" {
             self.presenter?.presentAlertView(message: "Cities not found")
         } else {
             DispatchQueue.main.async {
                 self.presenter?.presentCities(queryString: queryString)
             }
         }
            
            completion(true)
         }
        
        

    }
    
//    func getCitiesFromJSON(cityNames: String) {
//    }

   func validateString(array: [String]?) -> Bool {
       guard let array = array else {
           return false
       }
       guard array.count >= 3 && array.count <= 7 else {
           return false
       }
       return true
   }
    
    // File Read
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
