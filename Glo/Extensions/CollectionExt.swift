//
//  CollectionExt.swift
//  Glo
//
//  Created by Kevin on 3/29/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import Foundation

extension Collection {
    
    /// Returns the element at the specified index if it is within bounds, otherwise nil.
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
