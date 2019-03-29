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
        super.init(coder: aDecoder)
    }
    
    func setup(label: Label) {
        
        let backView = UIView(frame: CGRect(x: 10, y: 5, width: self.frame.width - 20, height: self.frame.height - 10))
        self.contentView.addSubview(backView)
        
        self.contentView.backgroundColor = .clear
        self.contentView.clipsToBounds = false
        self.clipsToBounds = false
        backView.layer.shadowOffset = .zero
        backView.layer.shadowColor = label.color.cgColor
        backView.layer.shadowRadius = 5
        backView.layer.shadowOpacity = 1
        backView.layer.shadowPath = UIBezierPath(rect: backView.bounds).cgPath
        
        
        let text = UILabel(frame: CGRect(x: 0, y: 0, width: backView.frame.width, height: backView.frame.height))
        text.font = UIFont(name: "System", size: CGFloat(17))
        text.text = label.name
        text.textColor = label.color.isDarkColor ? .white : .black
        text.textAlignment = .center
        backView.addSubview(text)
        

    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.contentView.subviews.forEach({ $0.removeFromSuperview() })
    }
}
