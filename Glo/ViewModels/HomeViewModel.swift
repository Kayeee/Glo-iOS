//
//  HomeViewModel.swift
//  Glo
//
//  Created by Kevin on 3/10/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import UIKit

class HomeViewModel {
    var boards: [Board]
    private var selectedBoard: Int?
    
    init(boards: [Board]) {
        self.boards = boards
        selectedBoard = boards.count > 0 ? 0 : nil
    }
    
    func getNameForSelectedBoard() -> String {
        guard let boardIndex = selectedBoard else { return "" }
        return boards[boardIndex].name
    }
    
    func changeSelectedBoard(index: Int, completion: @escaping() -> Void) {
        self.selectedBoard = index
        
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let strongSelf = self else { return }
            // load cards
            let group = DispatchGroup()
            let columns = strongSelf.boards[index].columns
            for columnIndex in 0..<columns.count {
                group.enter()
                let board = strongSelf.boards[strongSelf.selectedBoard!]
                GloNetworking.getCards(for: columns[columnIndex], board: board) { cards in
                    strongSelf.boards[index].columns[columnIndex].setCards(cards: cards)
                    group.leave()
                }
            }
            group.wait()
            completion()
        }
    }
    
    func getColumnsForSelectedBoard() -> [Column] {
        guard let boardIndex = selectedBoard else { return [] }
        return boards[boardIndex].columns
    }
    
    func getSelectedBoard() -> Board? {
        guard let selectedboard = self.selectedBoard else { return nil }
        return self.boards[selectedboard]
    }
    
    func updateCard(card: Card) {
        guard let selBoard = selectedBoard else { return }
        
        // update the card within the
        for (i, column) in boards[selBoard].columns.enumerated() {
            if column.id == card.column.id {
                boards[selBoard].columns[i].updateCard(card: card)
            }
        }
    }
    
    func addCard(card: Card) {
        guard let selBoard = selectedBoard else { return }
        
        // update the card within the
        for (i, column) in boards[selBoard].columns.enumerated() {
            if column.id == card.column.id {
                boards[selBoard].columns[i].addCard(card: card)
            }
        }
        print("here")
    }
}
