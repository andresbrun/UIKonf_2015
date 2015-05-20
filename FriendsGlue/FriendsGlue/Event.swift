//
//  Event.swift
//  FriendsGlue
//
//  Created by Romain Boulay on 20/05/15.
//  Copyright (c) 2015 Andres Brun Moreno. All rights reserved.
//

import Foundation

class EventHelper {
    static var dateFormatter: NSDateFormatter {
        var formatter = NSDateFormatter()
        formatter.dateStyle = .FullStyle
        return formatter
    }
}

struct Event {
    let distantID: Int?
    let userID: Int?
    var verb: String? // Event type
    var locationName: String?  // Event location name
    var latitude: Float?
    var longitude: Float?
    
    var date: NSDate? // Event date
    var friends: [APContact] // Friends invited
    

    
    static func createEvent(verb: String?, locationName: String?, latitude: Float?, longitude: Float?, date: NSDate?, friends: [APContact]) -> Event {
        return Event(distantID: nil, userID: nil, verb: verb, locationName: locationName, latitude: latitude, longitude: longitude, date: date, friends: friends)
    }
    
    // RECEIVE
    static func eventFrom(#json: Dictionary<String, AnyObject>) -> Event {
        let id = json["id"] as! Int
        let userID = json["user_id"] as! Int
        let verb = json["verb"] as! String
        let locationName = json["location"] as? String
        let latitude = json["latitude"] as? Float
        let longitude = json["longitude"] as? Float
        
        var date: NSDate?
        if let metadataValue = json["longitude"] as? Dictionary<String, AnyObject> {
            if let dateVale = metadataValue["longitude"] as? String {
                date = EventHelper.dateFormatter.dateFromString(dateVale)
            }
        }

        return Event(distantID: id, userID: userID, verb: verb, locationName: locationName, latitude: latitude, longitude: longitude, date: date, friends: [])
    }
    

    // SEND
    func tapGlueDistantDictionary() -> Dictionary<String, AnyObject> {
        var parameters = Dictionary<String, AnyObject>()
        parameters["verb"] = verb
        parameters["location"] = locationName
        parameters["latitude"] = latitude
        parameters["longitude"] = longitude
        parameters["metadata"] = toTapGlueMetadata()
        
        println("tapGlueDistantDictionary: \(parameters)")
        return parameters
    }
    
    private func toTapGlueMetadata() -> Dictionary<String, AnyObject> {
        var metadata = Dictionary<String, AnyObject>()
        metadata["friendCount"] = String(friends.count)
//        metadata["friendIDs"] = friends.map( {
//            if let emailValue = $0.emails[0] as? String {
//                return emailValue
//            }
//            else {
//                return ""
//            }
//        } )
        
        if let dateValue = date {
            metadata["date"] = EventHelper.dateFormatter.stringFromDate(dateValue)
        }
        
        return metadata
    }
}