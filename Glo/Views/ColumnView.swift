//
//  ColumnView.swift
//  Glo
//
//  Created by Kevin on 3/12/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import UIKit

class ColumnView: UIView {

    @IBOutlet var cardsTableView: UITableView!
    
    var column: Column! {
        didSet {
            cardsTableView.reloadData()
        }
    }

    override func awakeFromNib() {
        
    }
}

extension ColumnView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let cardCount = column.cards?.count  else { return 0 }
        return cardCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell") as! CardCell
        return cell
    }
    
    
}
