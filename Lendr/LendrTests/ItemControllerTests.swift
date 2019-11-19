//
//  ItemControllerTests.swift
//  LendrTests
//
//  Created by Isaac Lyons on 11/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import XCTest
import CoreData
@testable import Lendr

class ItemControllerTests: XCTestCase {

    override func setUp() {
        let context = CoreDataStack.shared.mainContext
        
        // Clear all of the items
        let itemsFetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        if let items = try? context.fetch(itemsFetchRequest) {
            for item in items {
                context.delete(item)
            }
        }
        
        // Clear all of the users
        let usersFetchRequest: NSFetchRequest<User> = User.fetchRequest()
        if let users = try? context.fetch(usersFetchRequest) {
            for user in users {
                context.delete(user)
            }
        }
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testFetchItems() {
        let context = CoreDataStack.shared.mainContext
        
        // Before starting, make sure there are no itmes
        do {
            let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
            let items = try context.fetch(fetchRequest)
            XCTAssertEqual(items, [])
        } catch {
            XCTFail("\(error)")
        }
        
        let itemController = ItemController()
        
        let mock = MockLoader()
        mock.data = validItemsJSON
        
        let client = NetworkingController(networkLoader: mock)
        
        let resultsExpectation = expectation(description: "Wait for the results")
        
        client.fetch(from: URL(string: "https://zero5nelsonm-lendr.herokuapp.com/items/items")!) { (itemRepresentations: [ItemRepresentation]?, error: Error?) in
            
            XCTAssertNil(error)
            guard let itemRepresentations = itemRepresentations else {
                XCTFail("No item representations fetched")
                return
            }
            
            do {
                try itemController.updateItems(from: itemRepresentations, context: context)
                
                // Fetch the items to make sure it worked
                let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
                let items = try context.fetch(fetchRequest)
                
                guard let item8 = items.first(where: { $0.id == 8 }) else {
                    XCTFail("Could not find item with id 8")
                    return
                }
                
                XCTAssertEqual(item8.name, "Chop Saw")
            } catch {
                XCTFail("\(error)")
            }
            
            resultsExpectation.fulfill()
        }
        
        wait(for: [resultsExpectation], timeout: 2)
    }
    
    func testCreatingUsersFromFetchedItems() {
        let context = CoreDataStack.shared.mainContext
        
        // Before starting, make sure there are no itmes
        do {
            let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
            let users = try context.fetch(fetchRequest)
            XCTAssertEqual(users, [])
        } catch {
            XCTFail("\(error)")
        }
        
        let itemController = ItemController()
        
        let mock = MockLoader()
        mock.data = validItemsJSON
        
        let client = NetworkingController(networkLoader: mock)
        
        let resultsExpectation = expectation(description: "Wait for the results")
        
        client.fetch(from: URL(string: "https://zero5nelsonm-lendr.herokuapp.com/items/items")!) { (itemRepresentations: [ItemRepresentation]?, error: Error?) in
            
            XCTAssertNil(error)
            guard let itemRepresentations = itemRepresentations else {
                XCTFail("No item representations fetched")
                return
            }
            
            do {
                try itemController.updateItems(from: itemRepresentations, context: context)
                
                // Fetch the items to make sure it worked
                let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
                let users = try context.fetch(fetchRequest)
                
                guard let allen = users.first(where: { $0.name == "Allen" }) else {
                    XCTFail("Could not find user Allen")
                    return
                }
                
                XCTAssertEqual(allen.name, "Allen")
            } catch {
                XCTFail("\(error)")
            }
            
            resultsExpectation.fulfill()
        }
        
        wait(for: [resultsExpectation], timeout: 2)
    }

}
