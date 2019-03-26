//
//  Label.swift
//  Glo
//
//  Created by Kevin on 3/13/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import UIKit

/*
 When creating Cards, API only returns id and name for the Label, a separate API call is needed for
 creating the actual label object with the color
 */
struct AbstractLabel: Codable {
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


struct Label: Codable {
    fileprivate(set) var id: String
    fileprivate(set) var name: String
    fileprivate(set) var color: UIColor
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
    
    private enum DecodingKeys: String, CodingKey {
        case id
        case name
        case color
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let color = try container.decode(Dictionary<String, Any>.self, forKey: .color)
        
        let red = color["r"] as! Int
        let green = color["g"] as! Int
        let blue = color["b"] as! Int
        
        let uiColor = UIColor(red: CGFloat(red)/255.0, green: CGFloat(green)/255.0, blue: CGFloat(blue)/255.0, alpha: 1)
        
        self.init(id: id, name: name, color: uiColor)
    }
    
    init(id: String, name: String, color: UIColor) {
        self.id = id
        self.name = name
        self.color = color
    }
}


