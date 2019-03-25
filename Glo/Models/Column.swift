//
//  column.swift
//  Glo
//
//  Created by Kevin on 3/10/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import Foundation

struct Column: Codable {
    
    fileprivate(set) var id: String
    fileprivate(set) var name: String
    var cards: [Card]?
    fileprivate(set) var boardID: String!
    
    private enum DecodingKeys: String, CodingKey {
        case id
        case name
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        
        self.init(id: id, name: name)
    }
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
    
    mutating func setBoardID(id: String) {
        self.boardID = id
    }
    
    mutating func setCards(cards: [Card]) {
        self.cards = cards
    }
}
