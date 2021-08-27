//
//  MarvelComicsDemoTests.swift
//  MarvelComicsDemoTests
//
//  Created by Michael Dautermann on 8/14/21.
//

import XCTest

@testable import MarvelComicsDemo

import SDWebImage

class MockComicsDataManager {
    var entries = [Comic]()
    func getData(startingWith: Int) {
        Swift.print("getting data")
    }
}

class MarvelComicsDemoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        Swift.print("setting up")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testDataManagerSuccessfulLoad() throws {
        let comicsDataManager = ComicsDataManager()
        if let path = Bundle(for: type(of: self)).path(forResource: "ValidComicData", ofType: "json") {
            let fileURL = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: fileURL, options: .uncachedRead)
                if let comicsResults = comicsDataManager.parse(data: data) {
                    Swift.print("comics results is \(comicsResults.count)")
                }
            } catch let err {
                XCTFail("can't load data - \(err)")
            }
        }
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
