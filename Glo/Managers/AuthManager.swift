//
//  KeyManager.swift
//  Glo
//
//  Created by Kevin on 3/8/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import Foundation
import KeychainAccess

enum AuthFailure {
    case noKeychainToken
    case invalidToken
}

struct AuthManager {
    static private var isAuthenticated: Bool = false
    static private var key: String?
    
    static func getIsAuthenticated() -> Bool {
        return self.isAuthenticated
    }
    
    static func getkey() -> String? {
        return self.key
    }
    
    static func authenticate(completion: @escaping(_ success: Bool, _ error: AuthFailure?) -> Void) {
        // todo remove. just for testing

        let keychain = Keychain(service: "com.branchcutapps.Glo")
        guard let key = keychain["glowPAT"] else {
            completion(false, .noKeychainToken)
            return
        }
        
        self.authenticate(with: key) { success in
            if success {
                completion(true, nil)
            } else {
                completion(false, .invalidToken)
            }
        }
    }
    
    static func authenticate(with key: String, completion: @escaping(_ success: Bool) -> Void) {
        // basically just run a test API call
        GloNetworking.authenticateUser(with: key) { success in
            if success {
                Keychain(service: "com.branchcutapps.Glo")["glowPAT"] = key
                self.isAuthenticated = true
                self.key = key
            }
            completion(success)
        }
    }
}
