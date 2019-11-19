//
//  NetworkingControllerTests.swift
//  LendrTests
//
//  Created by Isaac Lyons on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import XCTest
@testable import Lendr

class NetworkingControllerTests: XCTestCase {

    func testFetchItems() {
        let mock = MockLoader()
        mock.data = validItemsJSON
        
        let client = NetworkingController(networkLoader: mock)
        
        let resultsExpectation = expectation(description: "Wait for the results")
        
        client.fetch(from: URL(string: "https://zero5nelsonm-lendr.herokuapp.com/items/items")!) { (itemRepresentations: [ItemRepresentation]?, error: Error?) in
            XCTAssertNil(error)
            XCTAssertNotNil(itemRepresentations)
            
            // Find item with ID 8
            guard let item8 = itemRepresentations?.first(where: { $0.id == 8 }) else {
                XCTFail("Could not find item with id 8")
                return
            }
            
            XCTAssertEqual(item8.name, "Chop Saw")
            resultsExpectation.fulfill()
        }
        
        wait(for: [resultsExpectation], timeout: 2)
    }

}
