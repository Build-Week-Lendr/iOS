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
    let itemDescription: String?
    let lendNotes: String?
    let lentDate: String?
    
    enum ItemKeys: String, CodingKey {
        case name = "itemname"
        case id = "itemid"
        case holder = "lentto"
        case itemDescription = "itemdescription"
        case lendNotes = "lendnotes"
        case lentDate = "lentdate"
    }
    
    func encode (to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: ItemKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(holder, forKey: .holder)
        try container.encode(itemDescription, forKey: .itemDescription)
        try container.encode(lendNotes, forKey: .lendNotes)
        try container.encode(lentDate, forKey: .lentDate)
    }
}

extension ItemRepresentation {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: ItemKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int16.self, forKey: .id)
        holder = try container.decode(String?.self, forKey: .holder)
        itemDescription = try container.decode(String?.self, forKey: .itemDescription)
        lendNotes = try container.decode(String?.self, forKey: .lendNotes)
        lentDate = try container.decode(String?.self, forKey: .lentDate)
        
        owner = nil
    }
}
