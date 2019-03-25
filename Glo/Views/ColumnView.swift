//
//  ColumnView.swift
//  Glo
//
//  Created by Kevin on 3/12/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import UIKit

protocol SelectedCard {
    func selectedCard(card: Card)
}

class ColumnView: UIView {

    @IBOutlet var cardsTableView: UITableView!
    @IBOutlet var titleLabel: UILabel!
    
    var selectedCardDelegate: SelectedCard!
    var column: Column! {
        didSet {
            cardsTableView.reloadData()
            self.titleLabel.text = column.name
        }
    }

    override func awakeFromNib() {
        cardsTableView.delegate = self
        cardsTableView.dataSource = self
        
        self.backgroundColor = UIColor.columnBackground
    }
}

extension ColumnView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cardCount = column.cards?.count  else { return 0 }
        return cardCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let nib: UINib = UINib(nibName: "CardCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "CardCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath) as! CardCell
        
        guard let cards = self.column.cards else { return cell }
        cell.setUp(card: cards[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let cards = self.column.cards else { return }
        selectedCardDelegate.selectedCard(card: cards[indexPath.row])
    }
}
