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
        NetworkingController.signIn(token: "71ae686c-e5e7-432d-b0aa-65f0d96dc2a3")
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

    func testFetchItemsUpdate() {
        let context = CoreDataStack.shared.mainContext
        let itemController = ItemController()

        let mock = MockLoader()
        mock.data = validItemsJSON

        var client = NetworkingController(networkLoader: mock)

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

        mock.data = validItems2JSON
        client = NetworkingController(networkLoader: mock)

        let updatedResultsExpectation = expectation(description: "Wait for the updated results")

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

                XCTAssertNotEqual(item8.name, "Chop Saw")
                XCTAssertEqual(item8.name, "Chop Saw2")
            } catch {
                XCTFail("\(error)")
            }

            updatedResultsExpectation.fulfill()
        }

        wait(for: [updatedResultsExpectation], timeout: 2)
    }

    func testDateFormatting() {
        let context = CoreDataStack.shared.mainContext

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

                guard let item8 = items.first(where: { $0.id == 8 }),
                    let item8Date = item8.lentDate else {
                    XCTFail("Could not load date for item with id 8")
                    return
                }

                let item8DateString = itemController.dateFormatter.string(from: item8Date)
                XCTAssertEqual(item8DateString, "November 21, 2019")
            } catch {
                XCTFail("\(error)")
            }

            resultsExpectation.fulfill()
        }

        wait(for: [resultsExpectation], timeout: 2)
    }

    func testCreateItem() {
        let context = CoreDataStack.shared.mainContext

        let itemController = ItemController()

        let resultsExpectation = expectation(description: "Wait for the results")

        // This is so the item created will (likely) not already exist, as the test will fail if it does
        let randomNumber = Int.random(in: 0...99)

        itemController.createItem(named: "Test Item \(randomNumber)", itemDescription: "An item to test creating items", lendDate: nil, context: context) { createdItem, error in
            XCTAssertNil(error)
            XCTAssertNotNil(createdItem)
            XCTAssertEqual(createdItem?.name, "Test Item \(randomNumber)")

            resultsExpectation.fulfill()
        }

        wait(for: [resultsExpectation], timeout: 5)
    }

    func testDeleteItem() {
        let context = CoreDataStack.shared.mainContext

        let itemController = ItemController()

        let resultsExpectation = expectation(description: "Wait for the results")

        let name = "Test Item to delete"

        itemController.createItem(named: name,
                                  itemDescription: "An item to test deleting items",
                                  lendDate: nil, context: context) { createdItem, error in
            XCTAssertNil(error)
            XCTAssertNotNil(createdItem)
            XCTAssertEqual(createdItem?.name, name)

            itemController.deleteItem(createdItem!, context: context) { error in
                XCTAssertNil(error)

                let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "name == %@", name)

                do {
                    let results = try context.fetch(fetchRequest)
                    XCTAssertEqual(results, [])
                } catch {
                    XCTFail("\(error)")
                }

                resultsExpectation.fulfill()
            }
        }

        wait(for: [resultsExpectation], timeout: 5)
    }

    func testUpdateItem() {
        let context = CoreDataStack.shared.mainContext

        let itemController = ItemController()

        let resultsExpectation = expectation(description: "Wait for the results")

        let name = "Test item to be updated"
        let updatedName = "Test item that has been updated"

        itemController.createItem(named: name,
                                  itemDescription: "An item to test updating items",
                                  lendDate: nil, context: context) { createdItem, error in
            XCTAssertNil(error)
            XCTAssertNotNil(createdItem)
            XCTAssertEqual(createdItem?.name, name)

            itemController.updateItem(item: createdItem!,
                                      name: updatedName,
                                      holder: nil,
                                      itemDescription: nil,
                                      lendNotes: nil,
                                      lendDate: nil,
                                      context: context) { updatedItem, error in
                                        XCTAssertNil(error)
                                        XCTAssertNotNil(createdItem)
                                        XCTAssertEqual(updatedItem?.name, updatedName)
                                        resultsExpectation.fulfill()
            }
        }

        wait(for: [resultsExpectation], timeout: 5)
    }

}
