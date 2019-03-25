//
//  Board.swift
//  Glo
//
//  Created by Kevin on 3/10/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import Foundation

struct Board: Codable {
    
    fileprivate(set) var id: String
    fileprivate(set) var name: String
    var columns: [Column]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    private enum DecodingKeys: String, CodingKey {
        case id
        case name
        case columns
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        var columns = try container.decode([Column].self, forKey: .columns)
        for index in 0..<columns.count {
            columns[index].setBoardID(id: id)
        }
        
        self.init(id: id, name: name, columns: columns)
    }
    
    init(id: String, name: String, columns: [Column]) {
        self.id = id
        self.name = name
        self.columns = columns
    }
}

