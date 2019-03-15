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
    @IBOutlet var labelsCollectionView: LabelCollectionView!
    
    var card: Card!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setUp(card: Card) {
        self.card = card
        self.titleLabel.text = card.name
        
        self.labelsCollectionView.delegate = self
        self.labelsCollectionView.dataSource = self
        self.labelsCollectionView.register(LabelCell.self, forCellWithReuseIdentifier: "Cell")
        self.labelsCollectionView.contentInset = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5);
        self.labelsCollectionView.allowsSelection = false
        
        self.labelsCollectionView.reloadData()
    }
}


extension CardCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.card.labels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LabelCell
        let label = self.card.labels[indexPath.row]
        cell.setup(text: label.name)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (self.issue.labels![indexPath.row].name as NSString).size(withAttributes: nil)
        let height = CGFloat(35)
        return CGSize(width: size.width*1.5 + 20, height: height)
    }
}
