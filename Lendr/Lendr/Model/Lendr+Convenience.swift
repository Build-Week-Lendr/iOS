//
//  Lendr+Convenience.swift
//  Lendr
//
//  Created by Isaac Lyons on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import CoreData

extension User {
    @discardableResult convenience init(name: String, id: String = UUID().uuidString, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.name = name
        self.id = id
    }
}

extension Item {
    
    var representation: ItemRepresentation? {
        guard let name = name,
            let id = id,
            let owner = owner,
            let ownerId = owner.id else { return nil }
        
        return ItemRepresentation(name: name, id: id, owner: ownerId, holder: holder?.id)
    }
    
    @discardableResult convenience init(name: String, id: String = UUID().uuidString, context: NSManagedObjectContext) {
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
