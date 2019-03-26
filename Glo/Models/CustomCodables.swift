//
//  CustomCodables.swift
//  Glo
//
//  Created by Kevin on 3/25/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import Foundation

struct CodableID: Codable {
    fileprivate(set) var id: String
    
    private enum CodingKeys: String, CodingKey {
        case id
    }
    
    private enum DecodingKeys: String, CodingKey {
        case id
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        
        self.init(id: id)
    }
    
    init(id: String) {
        self.id = id
    }
}
