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
    
    func createTestUser(success: (() -> Void), failure: ((AnyObject)? -> Void)?) {
        let request = authenticatedMutableURLRequest("https://api.tapglue.com/0.2/users?withLogin=true", httpMethod: "POST")
        
        let parameters = [
            "user_name": "FriendsGlue",
            "first_name": "John",
            "last_name": "Smith",
            "email": "bananakit@github.com",
            "password": "password"
        ]
        
        let postData = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: nil)
        request.HTTPBody = postData
        
        self.request(request, success: { [unowned self] (json, response) -> Void in
            println(json)
            
            if let jsonValue = json as? Dictionary<String, AnyObject> {
                if let session = jsonValue["session_token"] as? String {
                    self.sessionToken = session
                    println("token \(self.sessionToken)")
                }
                else {
                    println("no token...")
                }
            }
            success()
            }, failure: failure)
    }
    
    func requestSessionToken(success: (() -> Void), failure: ((AnyObject)? -> Void)?) {
        let request = authenticatedMutableURLRequest("https://api.tapglue.com/0.2/user/login", httpMethod: "POST")
        
        let parameters = [
            "email": "bananakit@github.com",
            "password": "password"
        ]
        let postData = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: nil)
        request.HTTPBody = postData
        
        self.request(request, success: { [unowned self] (json, response) -> Void in
            println(json)
            
            if let jsonValue = json as? Dictionary<String, AnyObject> {
                if let session = jsonValue["session_token"] as? String {
                    self.sessionToken = session
                    println("token \(self.sessionToken)")
                }
                else {
                    println("no token...")
                }
            }
            success()
            }, failure: failure)
    }
    
    private func request(request: NSURLRequest, success: ((json: AnyObject?, response: NSHTTPURLResponse?) -> Void)?, failure: ((AnyObject)? -> Void)?) {
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            
            var parseError: NSError?
            let parsedObject = NSJSONSerialization.JSONObjectWithData(data,
                options: NSJSONReadingOptions.AllowFragments,
                error:&parseError)
            
            if let httpResponse = response as? NSHTTPURLResponse {
                println("httpResponse")
                println(httpResponse)
                
                if (httpResponse.statusCode >= 100 && httpResponse.statusCode < 300) {
                    println("success")
                    if let successBlock = success {
                        successBlock(json: parsedObject, response: httpResponse)
                    }
                    
                    return
                }
            }
            
            println("failure")
            if let failureBlock = failure {
                if (error != nil) {
                    failureBlock(error)
                }
                else {
                    failureBlock(parsedObject)
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