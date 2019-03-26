//
//  Board.swift
//  Glo
//
//  Created by Kevin on 3/10/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import Foundation
/*
 since we can't get all board info from one 'boards' api call, we have to make a call for each board.
 Make call to 'boards' and make [AbstractBoard] from result. Loop through results and call 'board' each time
 and create a Board object from each result
*/
struct AbstractBoard: Codable {
    fileprivate(set) var id: String
    fileprivate(set) var name: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
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


struct Board: Codable {
    
    fileprivate(set) var id: String
    fileprivate(set) var name: String
    var columns: [Column]
    var members: [Member]
    var labels: [Label]
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case columns
        case members
        case labels
    }
    
    private enum DecodingKeys: String, CodingKey {
        case id
        case name
        case columns
        case members
        case labels
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        var columns = try container.decode([Column].self, forKey: .columns)
        for index in 0..<columns.count {
            columns[index].setBoardID(id: id)
        }
        let members = try container.decode([Member].self, forKey: .members)
        let labels = try container.decode([Label].self, forKey: .labels)
        
        self.init(id: id, name: name, columns: columns, members: members, labels: labels)
    }
    
    init(id: String, name: String, columns: [Column], members: [Member], labels: [Label]) {
        self.id = id
        self.name = name
        self.columns = columns
        self.members = members
        self.labels = labels
    }
}

