//
//  LandingViewControllerTests.swift
//  AKWeatherTests
//
//  Created by Atif Khan on 20/05/2020.
//  Copyright © 2020 Atif Khan. All rights reserved.
//

import XCTest
import UIKit
import Foundation
@testable import AKWeather

class MockLandingPresenter: LandingPresentationLogic {
    
    var expectedResult: String = "nil"
    
    func presentCities(queryString: String) {
        expectedResult = queryString
    }
    
    func presentAlertView(message: String) {
        expectedResult = message
    }
    
    func presentLoader() {
        
    }
    
    func hideLoader() {
        
    }
    
    
}

class LandingInteractorTests: XCTestCase {
    
    var sut: LandingInteractor?
    
    var presenter: MockLandingPresenter?

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        presenter = MockLandingPresenter()
        
        sut = LandingInteractor(presenter: presenter!)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testIFUSerNotEnterAtleastThree() {
        let testData = "Dubai"
        sut?.getCitiesFromJSON(cityNames: testData, completion: {_ in })
        
        let expectedString =  "Number of cities should be between 3 and 7"
        XCTAssertEqual(expectedString, presenter?.expectedResult ?? "")
        
    }
    
    func testIfUserEnterMoreThan7Cities() {
        let testData = "Dubai, Sharjah, Abu Dhabi, Tokyo, Sydney, London, Islamabad, Lahore"
        sut?.getCitiesFromJSON(cityNames: testData, completion: {_ in})
        
        let expectedString =  "Number of cities should be between 3 and 7"
        XCTAssertEqual(expectedString, presenter?.expectedResult ?? "")
    }
    
    func testIfUserEnterCorrectNumberOFCities(){
        let testData = "Dubai, Sharjah, Abu Dhabi"
        
        let expectation = XCTestExpectation(description: "Wait for API")
        
        sut?.getCitiesFromJSON(cityNames: testData, completion: { (success) in
            expectation.fulfill()
        })
        
        wait(for: [expectation], timeout: 30.0)
        
        let expectedString =  "292223,292672,292968"
        XCTAssertEqual(expectedString, self.presenter?.expectedResult ?? "")
    }
    

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
