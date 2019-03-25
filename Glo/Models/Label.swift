//
//  Label.swift
//  Glo
//
//  Created by Kevin on 3/13/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import Foundation

struct Label: Codable {
    fileprivate(set) var id: String
    fileprivate(set) var name: String
    
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
}
