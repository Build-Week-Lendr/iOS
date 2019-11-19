//
//  Lendr+Convenience.swift
//  Lendr
//
//  Created by Isaac Lyons on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import CoreData

extension User {
    
    var representation: UserRepresentation? {
        guard let name = name,
            let id = id,
            let ownedItemsArray = ownedItems?.allObjects as? [Item],
            let heldItemsArray = heldItems?.allObjects as? [Item] else { return nil }
        
        let ownedItemIDs = ownedItemsArray.compactMap({ $0.id })
        let heldItemIDs = heldItemsArray.compactMap({ $0.id })
        
        return UserRepresentation(name: name, id: id, ownedItems: ownedItemIDs, heldItems: heldItemIDs)
    }
    
    @discardableResult convenience init(name: String, id: String = UUID().uuidString, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.name = name
        self.id = id
    }
    
    @discardableResult convenience init(representation: UserRepresentation, context: NSManagedObjectContext) {
        self.init(name: representation.name,
                  id: representation.id,
                  context: context)
    }
}

extension Item {
    
    var representation: ItemRepresentation? {
        guard let name = name,
            let owner = owner,
            let ownerId = owner.id else { return nil }
        
        return ItemRepresentation(name: name, id: id, owner: ownerId, holder: holder?.id)
    }
    
    @discardableResult convenience init(name: String, id: Int16, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.name = name
        self.id = id
    }
    
    @discardableResult convenience init(representation: ItemRepresentation, context: NSManagedObjectContext) {
        self.init(name: representation.name,
                  id: representation.id,
                  context: context)
    }
}
