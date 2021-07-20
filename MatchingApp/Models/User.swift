//
//  User.swift
//  MatchingApp
//
//  Created by 720.nishioka on 2021/07/20.
//

import Foundation
import Firebase

class User {
    
    var email: String
    var name: String
    var createdAt: Timestamp
    
    init(dic: [String: Any]) {
        self.email = dic["email"] as? String ?? ""
        self.name = dic["name"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
    
}
