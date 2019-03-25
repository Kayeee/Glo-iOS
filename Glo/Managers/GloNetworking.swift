//
//  GloNetworking.swift
//  Glo
//
//  Created by Kevin on 3/8/19.
//  Copyright © 2019 Branch Cut. All rights reserved.
//

import Foundation
import Alamofire
import KeychainAccess


struct GloNetworking {
    
    static private var baseURL = "https://gloapi.gitkraken.com/v1/glo/"
    
    static func authenticateUser(with key: String, completion: @escaping(_ success: Bool) -> Void) {

        let url = baseURL + "boards"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.get.rawValue
        request.allHTTPHeaderFields = ["Content-Type": "application/json", "Authorization": "Bearer \(key)"]
    
        // Just a test request to make sure api key is valid
        Alamofire.request(request).validate().responseJSON { (response) in
            
            switch response.result {
            case .success:
                completion(true)
            case .failure:
                completion(false)
            }
        }
    }
    
    
    static func getBoards(completion: @escaping(_ boards: [Board]) -> Void) {
        guard let key = AuthManager.getkey() else {
            completion([])
            return
        }
        
        let url = baseURL + "boards"
        let params = ["fields": "columns,name"]
        let headers = ["Authorization": "Bearer \(key)"]
        
        let request = Alamofire.request(url, parameters: params, headers: headers)
        
        request.validate().responseData { (response) in
            
            switch response.result {
            case .success:
                do {
                    let data = response.result.value!
                    let boards = try JSONDecoder().decode([Board].self, from: data)
                    completion(boards)
                } catch {
                    print("error")
                    completion([])
                }     
            case .failure:
                completion([])
            }
        }
    }
    
    static func getCards(for column: Column, completion: @escaping(_ cards: [Card]) -> Void) {
        guard let key = AuthManager.getkey() else { return }
        
        let url = baseURL + "boards/\(column.boardID!)/columns/\(column.id)/cards"
        let params = ["fields": "description,labels,total_task_count,assignees,name,comment_count"]
        let headers = ["Authorization": "Bearer \(key)"]
        
        let request = Alamofire.request(url, parameters: params, headers: headers)
        
        request.validate().responseData { response in
            
            switch response.result {
            case .success:
                do {
                    let data = response.result.value!
                    let cards = try JSONDecoder().decode([Card].self, from: data)
                    completion(cards)
                } catch {
                    print("error")
                    completion([])
                }
            case .failure:
                completion([])
            }
        }
    }
}
