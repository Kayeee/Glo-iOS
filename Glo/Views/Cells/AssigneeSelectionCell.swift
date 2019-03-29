//
//  AssigneeSelectionCell.swift
//  Glo
//
//  Created by Kevin on 3/28/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import UIKit

class AssigneeSelectionCell: UITableViewCell {

    var assignee: Member? {
        didSet {
            guard let assignee = assignee else { return }
            self.setUp(assignee: assignee)
        }
    }
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected {
            self.backgroundColor = UIColor.cardBackground
        } else {
            self.backgroundColor = .clear
        }
    }
    
    private func setUp(assignee: Member) {
        
        self.selectionStyle = .none
        
        //Set textLabel stuff
        self.textLabel?.text = assignee.name
        self.textLabel?.font = UIFont(name: "System", size: CGFloat(20))
        self.textLabel?.textColor = .white
    }
}
