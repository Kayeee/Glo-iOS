//
//  UIAlertActionExt.swift
//  Glo
//
//  Created by Kevin on 3/31/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import UIKit

extension UIAlertAction {
    
    static let cancelAction: UIAlertAction = {
        return UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    }()
}
