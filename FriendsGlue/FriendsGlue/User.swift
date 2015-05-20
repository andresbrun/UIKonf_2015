//
//  User.swift
//  FriendsGlue
//
//  Created by Romain Boulay on 20/05/15.
//  Copyright (c) 2015 Andres Brun Moreno. All rights reserved.
//

import Foundation

struct User {
    let distantID: Int
    let firstName: String?
    let lastName: String?
    let email: String
    
    static func userFrom(#dictionary: Dictionary<String, AnyObject>) -> User {
        let id = dictionary["id"] as! Int
        let email = dictionary["email"] as! String
        let firstName = dictionary["first_name"] as? String
        let lastName = dictionary["last_name"] as? String
        
        return User(distantID: id, firstName: firstName, lastName: lastName, email: email)
    }
}

