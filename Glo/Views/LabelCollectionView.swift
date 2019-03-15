//
//  LabelCollectionView.swift
//  Glo
//
//  Created by Kevin on 3/13/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import UIKit

class LabelCollectionView: UICollectionView {
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) {
            if hitView is LabelCollectionView {
                return nil
            } else {
                return hitView
            }
        } else {
            return nil
        }
    }
}

