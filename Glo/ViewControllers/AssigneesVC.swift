//
//  AssigneesVC.swift
//  Glo
//
//  Created by Kevin on 3/27/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import UIKit

protocol SelectedAssignees {
    func selectedAssignees(assignees: [Member])
}

class AssigneesVC: UIViewController {

    @IBOutlet var assigneesTableView: UITableView!
    
    var selectedAssigneesDelegate: SelectedAssignees!
    var allMembers: [Member]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        assigneesTableView.delegate = self
        assigneesTableView.dataSource = self
    }
    

    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveAction(_ sender: Any) {
        let indexPaths = assigneesTableView.indexPathsForSelectedRows ?? []
        let selectedMembers = indexPaths.map { allMembers[$0.row] }
        selectedAssigneesDelegate.selectedAssignees(assignees: selectedMembers)
        self.dismiss(animated: true, completion: nil)
    }
}


extension AssigneesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allMembers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! AssigneeSelectionCell
        
        cell.assignee = self.allMembers[indexPath.row]
        
        return cell
    }
}
