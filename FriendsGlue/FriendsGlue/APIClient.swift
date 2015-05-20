//
//  APIClient.swift
//  FriendsGlue
//
//  Created by Romain Boulay on 20/05/15.
//  Copyright (c) 2015 Andres Brun Moreno. All rights reserved.
//

import Foundation


class APIClient {
    let appToken = "eb3244b31222c1c6c13c9fb1cdd4e29d"
    var sessionToken: String?
    static let sharedInstance = APIClient()
    
    func requestSessionToken(success: (() -> Void), failure: ((NSError)? -> Void)?) {
        let parameters = [
            "user_name": "Demo User",
            "first_name": "John",
            "last_name": "Smith",
            "email": "bananakit@github.com",
            "password": "password"
        ]
        
        let request = authenticatedMutableURLRequest("https://api.tapglue.com/0.2/users/create?withLogin=true", httpMethod: "POST")
        let postData = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: nil)
        request.HTTPBody = postData

        self.request(request, success: { [unowned self] (json, response) -> Void in
            println(json)
            
            if let session = json["session_token"] as? String {
                self.sessionToken = session
                println("token \(self.sessionToken)")
            }
            else {
                println("no token...")
            }
            success()
        }, failure: failure)
    }
    
    
    private func request(request: NSURLRequest, success: ((json: Dictionary<String, AnyObject>, response: NSHTTPURLResponse?) -> Void)?, failure: ((NSError)? -> Void)?) {
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                println(error)
                
                if let failureBlock = failure {
                    failureBlock(error)
                }
            } else {
                var parsedObject = Dictionary<String, AnyObject>()
                if let httpResponse = response as? NSHTTPURLResponse {
                    println("httpResponse")
                    println(httpResponse)
                    
                    var parseError: NSError?
                    parsedObject = NSJSONSerialization.JSONObjectWithData(data,
                        options: NSJSONReadingOptions.AllowFragments,
                        error:&parseError) as! Dictionary<String, AnyObject>
                    
                    println("success")
                    if let successBlock = success {
                        successBlock(json: parsedObject, response: httpResponse)
                    }
                }
                else {
                    println("failure")
                    if let failureBlock = failure {
                        failureBlock(nil)
                    }
                }
            }
        })
        
        dataTask.resume()
    }
    
    private func authenticatedMutableURLRequest(urlString: String, httpMethod: String = "GET") -> NSMutableURLRequest {
        var basicAuthString = appToken + ":"
        if let sessionTokenValue = sessionToken {
            basicAuthString + sessionTokenValue
        }
        println("basicAuthString: \(basicAuthString)")

        let basicAuthData = basicAuthString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = basicAuthData!.base64EncodedStringWithOptions(nil)
        let authString = "Basic \(base64EncodedCredential)"
        
        let headers = [
            "accept": "application/json",
            "content-type": "application/json",
            "authorization": authString
        ]
        println("headers: \(headers)")
        
        var request = NSMutableURLRequest(URL: NSURL(string: urlString)!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        request.HTTPMethod = httpMethod
        request.allHTTPHeaderFields = headers
        return request
    }
}