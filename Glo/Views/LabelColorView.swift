//
//  LabelColorView.swift
//  Glo
//
//  Created by Kevin on 3/13/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import UIKit

class LabelColorView: UIView {
    
    override var backgroundColor: UIColor? {
        didSet {
            if backgroundColor != nil && backgroundColor!.cgColor.alpha == 0 {
                backgroundColor = oldValue
            }
        }
    }
    
    convenience init(width: CGFloat, cellHeight: CGFloat) {
        let height = CGFloat(10)
        self.init(frame: CGRect(x: 0, y: cellHeight - height, width: width, height: height))
        self.layer.cornerRadius = 5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
