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
        
        var absBoards: [AbstractBoard] = []
        var boards: [Board] = []
       
        // Set background dispatch queue so to not interfere with Alamo fire
        DispatchQueue.global(qos: .background).async {
            let group = DispatchGroup()
            
            // Get Abstract Boards
            group.enter()
            self.getAbstractBoards { abstractBoards in
                absBoards = abstractBoards
                group.leave()
            }
            
            // Boards from abstractBoards
            group.wait()
            for abBoard in absBoards {
                group.enter()
                self.getBoard(for: abBoard.id) { board in
                    guard let board = board else { group.leave(); return }
                    
                    boards.append(board)
                    group.leave()
                }
            }
            
            // execute completion handler
            group.wait()
            completion(boards)
        }
    }
    
    static func getAbstractBoards(completion: @escaping(_ boards: [AbstractBoard]) -> Void) {
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
                    let abstractBoards = try JSONDecoder().decode([AbstractBoard].self, from: data)
                    completion(abstractBoards)
                } catch {
                    print("error")
                    completion([])
                }     
            case .failure:
                completion([])
            }
        }
        
    }
    
    static func getBoard(for id: String, completion: @escaping(_ board: Board?) -> Void) {
        guard let key = AuthManager.getkey() else {
            completion(nil)
            return
        }
        
        let url = baseURL + "boards/\(id)"
        let params = ["fields": "members,labels,name,columns"]
        let headers = ["Authorization": "Bearer \(key)"]
        
        let request = Alamofire.request(url, parameters: params, headers: headers)
        
        request.validate().responseData { (response) in
            
            switch response.result {
            case .success:
                do {
                    let data = response.result.value!
                    let board = try JSONDecoder().decode(Board.self, from: data)
                    completion(board)
                } catch {
                    print("error")
                    completion(nil)
                }
            case .failure:
                completion(nil)
            }
        }
    }
    
    static func getCards(for column: Column, board: Board, completion: @escaping(_ cards: [Card]) -> Void) {
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
                    var cards = try JSONDecoder().decode([Card].self, from: data)
                    for idx in 0..<cards.count {
                        cards[idx].setBoardValues(for: board)
                        cards[idx].column = column
                    }
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
    
    static func updateCard(for card: Card, completion: @escaping(_ error: Error?) -> Void) {
        guard let key = AuthManager.getkey() else { return }
        
        let url = baseURL + "boards/\(card.board.id)/cards/\(card.id)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.allHTTPHeaderFields = ["Content-Type": "application/json", "Authorization": "Bearer \(key)"]
        
        let encoder = JSONEncoder()
        let data = try! encoder.encode(card)
        
        request.httpBody = data
        
        print("Data: \(String(decoding: data, as: UTF8.self))")
        
        Alamofire.request(request).validate().responseData { (response) in
            switch response.result {
            case .success:
                completion(nil)
            case .failure(let error):
                completion(error)
            }
        }
    }
} 
