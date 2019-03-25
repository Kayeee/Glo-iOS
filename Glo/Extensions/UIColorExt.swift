//
//  UIColorExt.swift
//  Glo
//
//  Created by Kevin on 3/9/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(hexFromString:String, alpha:CGFloat = 1.0) {
        var cString:String = hexFromString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        var rgbValue:UInt32 = 10066329 //color #999999 if string has wrong format
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) == 6) {
            Scanner(string: cString).scanHexInt32(&rgbValue)
        }
        
        self.init(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
    
    static let cardBackground: UIColor = {
        let color = UIColor(hexFromString: "32485b")
        return color
    }()
    
    static let columnBackground: UIColor = {
        let color = UIColor(hexFromString: "263949")
        return color
    }()
    
    static let boardBackground: UIColor = {
        let color = UIColor(hexFromString: "1c252b")
        return color
    }()
    
    static let textFieldBackground: UIColor = {
        let color = UIColor(hexFromString: "213341")
        return color
    }()
}

