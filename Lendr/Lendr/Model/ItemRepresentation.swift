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
    let id: Int16
    let owner: String?
    let holder: String?
    
    enum ItemKeys: String, CodingKey {
        case name = "itemname"
        case id = "itemid"
        case holder = "lentto"
    }
}

extension ItemRepresentation {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ItemKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int16.self, forKey: .id)
        holder = try container.decode(String?.self, forKey: .holder)
        
        owner = nil
    }
}
