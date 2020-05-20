//
//  AKWeatherTests.swift
//  AKWeatherTests
//
//  Created by Atif Khan on 19/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import XCTest
@testable import AKWeather

class AKWeatherTests: XCTestCase {

    var client:  HttpClient!
    let mockSession = MockURLSession()
        
        override func setUp() {
            client = HttpClient(session: mockSession)
        }

        override func tearDown() {
            // Put teardown code here. This method is called after the invocation of each test method in the class.
        }

        func testBaseUrl() {

    //        let path = "data/2.5/group"
            
            client.load(path: "", method: .get, params: [:]) { (data, error) in
                
            }
            
            XCTAssertNotNil(mockSession.lastURL, "Base Url should not be nil")
        }
        
        func testGetRequestWithQueryParams() {
            
            let expectedData = "{}".data(using: .utf8)
            
            mockSession.nextData = expectedData
            
            let path = "data/2.5/group"
            
            var actualData: Data?
            client.load(path: path, method: .get, params: ["id": "1174872, 292223"]) { (data, error) in
                actualData = data as? Data
            }
            
            XCTAssertNotNil(actualData)
        }
        

}
