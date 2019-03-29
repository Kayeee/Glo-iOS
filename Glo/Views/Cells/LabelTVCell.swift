//
//  LabelTVCell.swift
//  
//
//  Created by Kevin on 3/27/19.
//

import UIKit

class LabelTVCell: UITableViewCell {

    @IBOutlet var colorView: UIView!
    @IBOutlet var titleLabel: UILabel!
    
    var label: Label? {
        didSet {
            guard let label = label else { return }
            self.setUp(label: label)
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
//        guard let label = label else {
//            return
//        }
//        let size = (label.name as NSString).size(withAttributes: nil)
//        DispatchQueue.main.async {
//            self.colorView.frame = CGRect(x: self.colorView.frame.minX, y: self.colorView.frame.minY, width: size.width, height: self.colorView.frame.height)
//        }
//        
//        self.colorView.backgroundColor = label.color
//        
//        self.titleLabel.text = label.name
//        self.titleLabel.font = UIFont(name: "System", size: CGFloat(20))
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        let color = colorView.backgroundColor
        super.setSelected(selected, animated: animated)
        
        if selected {
            colorView.backgroundColor = color
            self.backgroundColor = UIColor.cardBackground
        } else {
            self.backgroundColor = .clear
        }
    }
    
    private func setUp(label: Label) {
        
        // Set background color when selected
        self.selectionStyle = .none

        
        // Create color view
        let size = (label.name as NSString).size(withAttributes: nil)
        self.colorView.frame = CGRect(x: self.colorView.frame.minX, y: self.colorView.frame.minY, width: size.width*1.5, height: self.colorView.frame.height)
        
        self.colorView.backgroundColor = .clear
        self.colorView.clipsToBounds = false
        self.clipsToBounds = false
        colorView.layer.shadowOffset = .zero
        colorView.layer.shadowColor = label.color.cgColor
        colorView.layer.shadowRadius = 5
        colorView.layer.shadowOpacity = 1
        colorView.layer.shadowPath = UIBezierPath(rect: colorView.bounds).cgPath
        
        //Set textLabel stuff
        self.titleLabel.text = label.name
        self.titleLabel.font = UIFont(name: "System", size: CGFloat(20))
        self.titleLabel.sizeToFit()
        self.titleLabel.textColor = label.color.isDarkColor ? .white : .black
    }
}
