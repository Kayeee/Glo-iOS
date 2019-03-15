//
//  LabelCell.swift
//  Glo
//
//  Created by Kevin on 3/13/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import UIKit

class LabelCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(text: String) {
        
        let label = UILabel(frame: CGRect(x: 3, y: 0, width: self.frame.width, height: self.frame.height))
        label.font = UIFont(name: "Avenir-Light", size: CGFloat(17))
        label.text = text
        label.textColor = .black
        label.textAlignment = .center
        label.sizeToFit()
        self.contentView.addSubview(label)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentView.subviews.forEach({ $0.removeFromSuperview() })
    }
}
