//
//  LabelsVC.swift
//  Glo
//
//  Created by Kevin on 3/27/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import UIKit

protocol SelectedLabels {
    func selectedLabels(labels: [Label])
}

class LabelsVC: UIViewController {

    @IBOutlet var labelsTableView: UITableView!
    
    var selectedLabelsDelegate: SelectedLabels!
    var allLabels: [Label]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        labelsTableView.dataSource = self
        labelsTableView.delegate = self
        
        labelsTableView.register(LabelTVCell.nib, forCellReuseIdentifier: "Cell")
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let indexPaths = labelsTableView.indexPathsForSelectedRows ?? []
        let selectedLabels = indexPaths.map { allLabels[$0.row] }
        selectedLabelsDelegate.selectedLabels(labels: selectedLabels)
        self.dismiss(animated: true, completion: nil)
    }
}

extension LabelsVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allLabels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LabelTVCell
        
        cell.label = allLabels[indexPath.row]
        cell.textLabel?.textColor = .white
        
        return cell
    }
}
