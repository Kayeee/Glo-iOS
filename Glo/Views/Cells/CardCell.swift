//
//  CardCell.swift
//  Glo
//
//  Created by Kevin on 3/13/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import UIKit

class CardCell: UITableViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subContentView: UIView!
    
    var card: Card!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {

    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {

    }
    
    func setUp(card: Card) {
        self.card = card
        self.titleLabel.text = card.name
           
        self.autoresizesSubviews = true
        self.subContentView.backgroundColor = UIColor.cardBackground
        self.subContentView.layer.cornerRadius = 10
        self.subContentView.layer.masksToBounds = true
        self.titleLabel.layer.cornerRadius = 10
        self.titleLabel.layer.masksToBounds = true
    }
}


extension CardCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.card.labels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LabelCell
        let label = self.card.labels[indexPath.row]
        cell.setup(label: label)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (self.card.labels[indexPath.row].name as NSString).size(withAttributes: nil)
        let height = CGFloat(35)
        return CGSize(width: size.width*1.5 + 20, height: height)
    }
}
