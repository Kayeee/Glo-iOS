//
//  HomeHeaderView.swift
//  Glo
//
//  Created by Kevin on 3/10/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import UIKit

class HomeHeaderView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.columnBackground
    }
}
