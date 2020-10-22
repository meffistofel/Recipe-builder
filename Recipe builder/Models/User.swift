//
//  User.swift
//  Recipe builder
//
//  Created by Oleksandr Kovalov on 22.10.2020.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(user: Firebase.User) {
        self.uid = user.uid
        self.email = user.email!
    }
}
