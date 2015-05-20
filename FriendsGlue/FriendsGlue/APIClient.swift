//
//  APIClient.swift
//  FriendsGlue
//
//  Created by Romain Boulay on 20/05/15.
//  Copyright (c) 2015 Andres Brun Moreno. All rights reserved.
//

import Foundation

class APIClient {
    func request(request: NSURLRequest, success: ((NSData, NSHTTPURLResponse?) -> Void)?, failure: ((NSError) -> Void)?) {
        let basicAuthString = "APP_TOKEN" + ":" + "SESSION_TOKEN"
        let basicAuthData = basicAuthString.dataUsingEncoding(NSUTF8StringEncoding)
        let base64EncodedCredential = basicAuthData!.base64EncodedStringWithOptions(nil)
        let authString = "Basic \(base64EncodedCredential)"
        
        let headers = [
            "accept": "application/json",
            "authorization": authString
        ]
        
        var request = NSMutableURLRequest(URL: NSURL(string: "https://api.tapglue.com/0.2/user")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                println(error)
                
                if let failureBlock = failure {
                    failureBlock(error)
                }
            } else {
                let httpResponse = response as? NSHTTPURLResponse
                println(httpResponse)
                
                if let successBlock = success {
                    successBlock(data, httpResponse)
                }
            }
        })
        
        dataTask.resume()
    }
}