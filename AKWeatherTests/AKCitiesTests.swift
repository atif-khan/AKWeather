//
//  AKWeatherTests.swift
//  AKWeatherTests
//
//  Created by Atif Khan on 19/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import XCTest
@testable import AKWeather

class AKCitiesTests: XCTestCase {
        
        override func setUp() {
        }

        override func tearDown() {
            // Put teardown code here. This method is called after the invocation of each test method in the class.
        }

    func testCityFileExists() {
        let path = Bundle.main.path(forResource: "city.list", ofType: "json", inDirectory: nil, forLocalization: nil)
        
        let fileManager = FileManager()
        
        XCTAssertTrue(fileManager.fileExists(atPath: try XCTUnwrap(path)), "File does not exist at path")
    }
    
    func testCityDataIsValid() {
        
        let path = Bundle.main.path(forResource: "city.list", ofType: "json", inDirectory: nil, forLocalization: nil)
        
        let fileManager = FileManager()
        
        if fileManager.fileExists(atPath: path!) {
            
            let data = try! Data.init(contentsOf: URL(fileURLWithPath: path!))
            XCTAssertNoThrow(try! JSONSerialization.jsonObject(with: data, options: .allowFragments))
        }
    }
}
