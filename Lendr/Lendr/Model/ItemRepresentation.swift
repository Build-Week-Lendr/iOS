//
//  ItemRepresentation.swift
//  Lendr
//
//  Created by Isaac Lyons on 11/18/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import Foundation

struct ItemRepresentation: Codable {
    let name: String
    let id: String
    let owner: String
    let holder: String
}
