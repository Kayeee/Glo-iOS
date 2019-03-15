//
//  AuthVC.swift
//  Glo
//
//  Created by Kevin on 3/8/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import UIKit
import KeychainAccess


protocol GloAuthenticated {
    func wasAuthenticated()
}


class AuthVC: UIViewController {

    var authDelegate: GloAuthenticated!
    
    @IBOutlet var tokenField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.columnBackground
        self.tokenField.backgroundColor = UIColor.textFieldBackground
        self.tokenField.attributedPlaceholder = NSAttributedString(string: "Token", attributes: [.foregroundColor: UIColor(hexFromString: "FFFFFF", alpha: 0.75)])
        self.tokenField.delegate = self
    }
    
    @IBAction func authAction() {
        guard let token = tokenField.text else { print("Empty token field"); return }
        
        AuthManager.authenticate(with: token) { [weak self] success in
            guard let strongSelf = self else { return }
            
            if success {
                self?.view.endEditing(true)
                strongSelf.authDelegate.wasAuthenticated()
                self?.dismiss(animated: true, completion: nil)
                
            } else {
                self?.displayErrorAlertWithOK(title: "Invalid Token", message: "Please check your token value")
            }
        }
    }
}

extension AuthVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = nil
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.placeholder = "Token"
    }
}
