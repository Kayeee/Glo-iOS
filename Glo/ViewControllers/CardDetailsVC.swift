//
//  CardDetailsVC.swift
//  Glo
//
//  Created by Kevin on 3/24/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import UIKit

protocol SavedCard {
    func savedCard(card: Card)
}

class CardDetailsVC: UIViewController {
    
    var card: Card!
    var savedCardDelegate: SavedCard!
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var descriptionView: UITextView!
    @IBOutlet var assigneesTableView: UITableView!
    @IBOutlet var labelCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        self.view.backgroundColor = UIColor.columnBackground
        
        nameField.text = card.name
        descriptionView.text = card.description
    }
    
    @IBAction func saveAction(_ sender: Any) {
        guard let name = nameField.text else {
            self.displayErrorAlertWithOK(title: "Name is required", message: "")
            return
        }
        card.name = name
        card.description = descriptionView.text
        
        self.showLoadingScreen(message: "Saving..") { [weak self] in
            guard let strongSelf = self else { return }
            
            GloNetworking.updateCard(for: strongSelf.card) { error in
                strongSelf.dismiss(animated: true) {
                    self?.dismiss(animated: true, completion: nil)
                }
            }
            
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
}
