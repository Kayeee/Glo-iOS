//
//  Member.swift
//  Glo
//
//  Created by Kevin on 3/24/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import Foundation

struct Member: Codable {
    
    fileprivate(set) var id: String
    fileprivate(set) var name: String
    fileprivate(set) var username: String
    fileprivate(set) var role: String
    
    private enum CodingKeys: String, CodingKey {
        case id
        case username
        case name
        case role
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let username = try container.decode(String.self, forKey: .username)
        let role = try container.decode(String.self, forKey: .role)
        
        self.init(id: id, name: name, username: username, role: role)
    }
    
    init(id: String, name: String, username: String, role: String) {
        self.id = id
        self.name = name
        self.username = username
        self.role = role
    }
}
