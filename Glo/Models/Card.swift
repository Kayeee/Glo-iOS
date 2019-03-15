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
    fileprivate(set) var description: String
    fileprivate(set) var labels: [Label]
}
