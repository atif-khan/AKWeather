//
//  String+AKW.swift
//  AKWeather
//
//  Created by Atif Khan on 20/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import Foundation

extension String {
    func trim() -> String {
        return self.trimmingCharacters(in: NSCharacterSet.whitespaces)
   }
}
