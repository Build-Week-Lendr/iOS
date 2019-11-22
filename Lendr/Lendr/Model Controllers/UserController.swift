//
//  UserController.swift
//  Lendr
//
//  Created by Isaac Lyons on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import CoreData

class UserController {

    @discardableResult func createUser(named name: String, userId: String?, context: NSManagedObjectContext) -> User {
        let user: User

        if let userId = userId {
            user = User(name: name, id: userId, context: context)
        } else {
            user = User(name: name, context: context)
        }

        CoreDataStack.shared.save(context: context)

        return user
    }

    func updateUser(user: User, name: String, context: NSManagedObjectContext) {
        user.name = name
        CoreDataStack.shared.save(context: context)
    }

    func deleteUser(user: User, context: NSManagedObjectContext) {
        context.delete(user)
        CoreDataStack.shared.save(context: context)
    }

}
