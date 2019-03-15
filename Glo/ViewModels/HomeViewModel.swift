//
//  HomeViewModel.swift
//  Glo
//
//  Created by Kevin on 3/10/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import Foundation

class HomeViewModel {
    fileprivate(set) var boards: [Board]
    private var selectedBoard: Int?
    
    init(boards: [Board]) {
        self.boards = boards
        selectedBoard = boards.count > 0 ? 0 : nil
    }
    
    func getNameForSelectedBoard() -> String {
        guard let boardIndex = selectedBoard else { return "" }
        return boards[boardIndex].name
    }
    
    func changeSelectedBoard(index: Int) {
        self.selectedBoard = index
    }
    
    func getColumnsForSelectedBoard() -> [Column] {
        guard let boardIndex = selectedBoard else { return [] }
        return boards[boardIndex].columns
    }
}
