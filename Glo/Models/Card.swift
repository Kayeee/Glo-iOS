//
//  Card.swift
//  Glo
//
//  Created by Kevin on 3/10/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import Foundation

struct Card: Codable {
    
    fileprivate(set) var id: String
    fileprivate(set) var name: String
    fileprivate(set) var description: String?
    fileprivate(set) var labels: [Label]
    
    private enum DecodingKeys: String, CodingKey {
        case id
        case name
        case description
        case labels
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let description = try container.decodeIfPresent([String: Any].self, forKey: .description)
        var descriptionText: String?
        if let unwrapDescrip = description {
            descriptionText = unwrapDescrip["text"] as? String
        }
        
        let labels = try container.decode([Label].self, forKey: .labels)
        
        self.init(id: id, name: name, description: descriptionText, labels: labels)
    }
    
    
    init(id: String, name: String, description: String?, labels: [Label]) {
        self.id = id
        self.name = name
        self.description = description
        self.labels = labels
    }
}
