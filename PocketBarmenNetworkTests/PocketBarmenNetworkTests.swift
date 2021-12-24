//
//  PocketBarmenNetworkTests.swift
//  PocketBarmenNetworkTests
//
//  Created by Oguzhan Ozturk on 2.11.2021.
//

import XCTest
@testable import PocketBarmen

class PocketBarmenNetworkTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCatagoryDetailFetch() throws{
        let sut = NetworkServiceManager.shared
        let detailRequest = CocktailDetailRequest(id: 11008)
        let expectation = XCTestExpectation(description: "Tamamlandı")
        sut.sendRequest(request: detailRequest) { (result : Result<CocktailDetailResponse , NetworkServiceError>) in
           
            switch result{
            case .success(let detail) :
                XCTAssert(true, detail.drinks[0].ingredients[0])
                expectation.fulfill()
            case .failure(let error) :
                XCTAssert(error == nil, error.localizedDescription)
                expectation.fulfill()
            }
            
        }
        
        self.wait(for: [expectation], timeout: 15)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}
