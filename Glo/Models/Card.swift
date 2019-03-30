//
//  Card.swift
//  Glo
//
//  Created by Kevin on 3/10/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import Foundation

struct Card: Codable {
    
    fileprivate(set) var id: String?
    var name: String
    var description: String?
    var column: Column!
    var board: Board!
    
    private var labelIDs: [CodableID]
    var labels: [Label] = []
    private var assigneeIDs: [CodableID]
    var assignees: [Member] = []
    
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case labels
        case assignees
        case column_id
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        let descriptObj = ["text": description ?? ""]
        try container.encode(descriptObj, forKey: .description)
        try container.encode(assignees, forKey: .assignees)
        try container.encode(labels, forKey: .labels)
        try container.encode(column.id, forKey: .column_id)
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let id = try container.decode(String.self, forKey: .id)
        let name = try container.decode(String.self, forKey: .name)
        let description = try container.decodeIfPresent([String: Any].self, forKey: .description)
        var descriptionText: String?
        if let unwrapDescrip = description {
            descriptionText = unwrapDescrip["text"] as? String
        }
        
        let labelIDs = try container.decode([CodableID].self, forKey: .labels)
        let assigneeIDs = try container.decode([CodableID].self, forKey: .assignees)
        
        self.init(id: id, name: name, description: descriptionText, labelIDs: labelIDs, assigneeIDs: assigneeIDs)
    }
    
    
    init(id: String?, name: String, description: String?, labelIDs: [CodableID], assigneeIDs: [CodableID]) {
        self.id = id
        self.name = name
        self.description = description
        self.labelIDs = labelIDs
        self.assigneeIDs = assigneeIDs
    }
    
    mutating func setBoardValues(for board: Board) {
        self.board = board
        self.setLabels(for: board)
        self.setAssignees(for: board)
    }
    
    mutating func setLabels(for board: Board) {
        self.labels = []
        // I'm aware of the O complexity of this. Likely won't have enough labels for it to matter though
        for absLabel in self.labelIDs {
            for label in board.labels {
                if label.id == absLabel.id {
                    self.labels.append(label)
                }
            }
        }
    }
    
    mutating func setAssignees(for board: Board) {
        self.assignees = []
        
        for assigneeID in self.assigneeIDs {
            for member in board.members {
                if assigneeID.id == member.id {
                    assignees.append(member)
                }
            }
        }
    }    
}
