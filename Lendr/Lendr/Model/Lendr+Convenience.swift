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
    @discardableResult convenience init(name: String, id: String = UUID().uuidString, context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.name = name
        self.id = id
    }
}
