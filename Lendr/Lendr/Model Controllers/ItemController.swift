//
//  ItemController.swift
//  Lendr
//
//  Created by Isaac Lyons on 11/19/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import CoreData

class ItemController {

    let dateFormatter: DateFormatter

    let networkingController = NetworkingController()

    init() {
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
    }

    func updateItems(from representations: [ItemRepresentation], context: NSManagedObjectContext) throws {

        // Fetch list of all users
        let usersFetchRequest: NSFetchRequest<User> = User.fetchRequest()
        let users = try context.fetch(usersFetchRequest)

        // Fetch items from the representation list that already exist
        let itemsFetchRequest: NSFetchRequest<Item> = Item.fetchRequest()

        let idsToFetch = representations.map({ $0.id })
        var representationsByID = Dictionary(uniqueKeysWithValues: zip(idsToFetch, representations))

        itemsFetchRequest.predicate = NSPredicate(format: "id IN %@", idsToFetch)

        let existingItems = try context.fetch(itemsFetchRequest)

        // Update items that already exist
        for item in existingItems {
            guard let representation = representationsByID[item.id] else { continue }

            item.name = representation.name

            representationsByID.removeValue(forKey: item.id)
        }

        // Create new items
        for representation in representationsByID.values {
            let item = Item(representation: representation, context: context)

            // Assign the owner of the item
            if let ownerName = representation.owner {
                if let owner = users.first(where: { $0.name == ownerName }) {
                    item.owner = owner
                } else {
                    // If a user doesn't exist with the owner's name, make a new user
                    let owner = User(name: ownerName, context: context)
                    item.owner = owner
                }
            }

            // Assign the holder of the item
            if let holderName = representation.holder {
                if let holder = users.first(where: { $0.name == holderName }) {
                    item.holder = holder
                } else {
                    // If a user doesn't exist with the holder's name, make a new user
                    let holder = User(name: holderName, context: context)
                    item.holder = holder
                }
            }

            // Assign the lent date of the item
            if let lentDateString = representation.lentDate,
                let lentDate = dateFormatter.date(from: lentDateString) {
                item.lentDate = lentDate
            }
        }

        CoreDataStack.shared.save(context: context)
    }

    func createItem(named name: String,
                    holder: User? = nil,
                    itemDescription: String? = nil,
                    lendNotes: String? = nil,
                    lendDate: Date? = Date(),
                    context: NSManagedObjectContext,
                    completion: @escaping (Item?, Error?) -> Void = { _, _ in }) {

        var lendDateString: String?

        if let lendDate = lendDate {
            lendDateString = dateFormatter.string(from: lendDate)
        }

        let itemRepresentation = ItemRepresentation(name: name,
                                                    id: 0,
                                                    owner: nil,
                                                    holder: holder?.name,
                                                    itemDescription: itemDescription,
                                                    lendNotes: lendNotes,
                                                    lentDate: lendDateString)

        let url = networkingController.baseURL
            .appendingPathComponent("items")
            .appendingPathComponent("item")

        networkingController.post(itemRepresentation, to: url) { _, response, error in

            if let error = error {
                completion(nil, error)
                return
            }

            guard let response = response as? HTTPURLResponse,
                let location = response.allHeaderFields["Location"] as? NSString,
                let itemID = Int16(location.lastPathComponent) else {
                completion(nil, NSError())
                return
            }

            let createdItemRepresentation = ItemRepresentation(name: name,
                                                               id: itemID,
                                                               owner: nil,
                                                               holder: holder?.name,
                                                               itemDescription: itemDescription,
                                                               lendNotes: lendNotes,
                                                               lentDate: lendDateString)

            let item = Item(representation: createdItemRepresentation, context: context)
            CoreDataStack.shared.save(context: context)
            completion(item, nil)
        }
    }

    func deleteItem(_ item: Item, context: NSManagedObjectContext, completion: @escaping (Error?) -> Void) {

        let url = networkingController.baseURL
            .appendingPathComponent("items")
            .appendingPathComponent("item")
            .appendingPathComponent("\(item.id)")

        networkingController.delete(from: url) { _, _, error in
            if let error = error {
                completion(error)
                return
            }

            context.delete(item)
            completion(nil)
        }
    }

    func updateItem(item: Item,
                    name: String,
                    holder: User?,
                    itemDescription: String?,
                    lendNotes: String?,
                    lendDate: Date?,
                    context: NSManagedObjectContext,
                    completion: @escaping (Item?, Error?) -> Void) {

        var lendDateString: String?

        if let lendDate = lendDate {
            lendDateString = dateFormatter.string(from: lendDate)
        }

        item.name = name
        item.holder = holder
        item.itemDescription = itemDescription
        item.lendNotes = lendNotes
        item.lentDate = lendDate

        var itemRepresentation = item.representation
        itemRepresentation?.lentDate = lendDateString

        let url = networkingController.baseURL
            .appendingPathComponent("items")
            .appendingPathComponent("item")
            .appendingPathComponent("\(item.id)")

        networkingController.post(itemRepresentation, to: url) { _, _, error in

            if let error = error {
                completion(nil, error)
                return
            }

            CoreDataStack.shared.save(context: context)
            completion(item, nil)
        }
    }

}
