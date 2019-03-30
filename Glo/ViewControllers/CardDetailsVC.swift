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
    func savedNewCard(card: Card)
}

class CardDetailsVC: UIViewController {
    
    var card: Card!
    var savedCardDelegate: SavedCard!
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var descriptionView: UITextView!
    @IBOutlet var assigneesTableView: UITableView!
    @IBOutlet var labelCollectionView: UICollectionView!
    
    @IBOutlet var assigneesLabel: UILabel!
    @IBOutlet var labelsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assigneesTableView.delegate = self
        assigneesTableView.dataSource = self
        
        labelCollectionView.delegate = self
        labelCollectionView.dataSource = self
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.view.addGestureRecognizer(tap)
        self.view.backgroundColor = UIColor.columnBackground
        
        let assigneesTap = UITapGestureRecognizer(target: self, action: #selector(segueToAssignees))
        let assigneesTap2 = UITapGestureRecognizer(target: self, action: #selector(segueToAssignees))
        self.assigneesLabel.addGestureRecognizer(assigneesTap)
        self.assigneesTableView.addGestureRecognizer(assigneesTap2)
        
        let labelsTap = UITapGestureRecognizer(target: self, action: #selector(segueToLabels))
        let labelsTap2 = UITapGestureRecognizer(target: self, action: #selector(segueToLabels))
        self.labelsLabel.addGestureRecognizer(labelsTap)
        self.labelCollectionView.addGestureRecognizer(labelsTap2)
        
        
        nameField.text = card.name
        
        descriptionView.text = card.description
        descriptionView.backgroundColor = UIColor.cardBackground
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
            
            if strongSelf.card.id != nil {
                GloNetworking.updateCard(for: strongSelf.card) { error in
                    strongSelf.dismiss(animated: true) {
                        strongSelf.savedCardDelegate.savedCard(card: strongSelf.card)
                        self?.dismiss(animated: true, completion: nil)
                    }
                }
            } else {
                GloNetworking.createCard(for: strongSelf.card) { [weak self] error, newCard in
                    guard let strongSelf = self else { return }
                    guard let newCard = newCard else { return }
                    
                    strongSelf.dismiss(animated: true) {
                        strongSelf.savedCardDelegate.savedNewCard(card: newCard)
                        self?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "Assignees":
            let dest = segue.destination as! AssigneesVC
            dest.allMembers = card.board.members
            dest.selectedAssigneesDelegate = self
        case "Labels":
            let dest = segue.destination as! LabelsVC
            dest.allLabels = card.board.labels
            dest.selectedLabelsDelegate = self
        default:
            break
        }
    }
    
    @objc
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc
    func segueToAssignees() {
        self.performSegue(withIdentifier: "Assignees", sender: self)
    }
    
    @objc
    func segueToLabels() {
        self.performSegue(withIdentifier: "Labels", sender: self)
    }
}


// MARK: - TABLE VIEW
extension CardDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.card.assignees.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.textColor = .white
        cell.textLabel?.text = self.card.assignees[indexPath.row].name
        cell.backgroundColor = .clear
        
        return cell
    }
}

// MARK: - COLLECTION VIEW
extension CardDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.card.labels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! LabelCell
        
        let label = self.card.labels[indexPath.row]
        cell.setup(label: label)
        
        return cell
    }
}

// MARK: - COLLECTION VIEW FLOW LAYOUT
extension CardDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size = (self.card.labels[indexPath.row].name as NSString).size(withAttributes: nil)
        let height = CGFloat(35)
        return CGSize(width: size.width*1.5 + 50, height: height)
    }
}

// MARK: - SELECTED ASSIGNEES
extension CardDetailsVC: SelectedAssignees {
    func selectedAssignees(assignees: [Member]) {
        self.card.assignees = assignees
        self.assigneesTableView.reloadData()
    }
}

// MARK: - SELECTED LABELS
extension CardDetailsVC: SelectedLabels {
    func selectedLabels(labels: [Label]) {
        self.card.labels = labels
        self.labelCollectionView.reloadData()
    }
}
