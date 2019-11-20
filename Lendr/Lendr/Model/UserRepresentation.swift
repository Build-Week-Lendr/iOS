//
//  UserRepresentation.swift
//  Lendr
//
//  Created by Isaac Lyons on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct UserRepresentation: Codable {
    let name: String
    let id: String
    let ownedItems: [Int16]
    let heldItems: [Int16]
}
