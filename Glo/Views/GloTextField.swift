//
//  UITextField.swift
//  Glo
//
//  Created by Kevin on 3/9/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import UIKit

class GloTextField: UITextField {
    override func awakeFromNib() {
        self.borderStyle = .none
        self.backgroundColor = UIColor.textFieldBackground
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
