//
//  Event.swift
//  FriendsGlue
//
//  Created by Romain Boulay on 20/05/15.
//  Copyright (c) 2015 Andres Brun Moreno. All rights reserved.
//

import Foundation

struct Event {
    let uid: Int
    let userID: Int
    let verb: String
    let locationName: String?
    let latitude: Float?
    let longitude: Float?
    
    static func eventFrom(#dictionary: Dictionary<String, AnyObject>) -> Event {
        let id = dictionary["id"] as! Int
        let userID = dictionary["user_id"] as! Int
        let verb = dictionary["verb"] as! String
        let locationName = dictionary["location"] as? String
        let latitude = dictionary["latitude"] as? Float
        let longitude = dictionary["longitude"] as? Float
        
        return Event(uid: id, userID: userID, verb: verb, locationName: locationName, latitude: latitude, longitude: longitude)
    }
}