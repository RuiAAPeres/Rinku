//
//  Rinku.swift
//  Rinku
//
//  Created by Rui Peres on 12/06/2014.
//  Copyright (c) 2014 Aphely. All rights reserved.
//

import Foundation

let RinkuPost : String = "POST"
let RinkuGet : String = "GET"

class Rinku {
    
    let request : NSMutableURLRequest
        
    init(httpMethod: String, endpointURL : String, httpHeaders : Dictionary<String, String>?) {
        
        let url = NSURL(string: endpointURL)
        request =  NSMutableURLRequest(URL: url)
        request.HTTPMethod = httpMethod
        
        if let httpHeadersUnWrapped = httpHeaders {
            request.allHTTPHeaderFields = httpHeadersUnWrapped
        }
    }
    
    // Class Methods
    
    class func post(url :String) -> Rinku {
        return Rinku(httpMethod: RinkuPost, endpointURL: url, httpHeaders: nil)
    }
    
    class func get(url :String) -> Rinku {
        return Rinku(httpMethod: RinkuGet, endpointURL: url, httpHeaders: nil)
    }
    
    // Instance Methods
    
    func headers(headers : Dictionary<String,String>) -> Rinku {
        request.allHTTPHeaderFields = headers
        return self
    }
    
    func body(httpBody : NSData) -> Rinku {
        request.HTTPBody = httpBody
        return self
    }

    func completion(completion : (NSData!, NSURLResponse!, NSError!) -> ()) -> () {
        
        var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil
            , delegateQueue: NSOperationQueue.mainQueue())
        
       session.dataTaskWithRequest(self.request, completionHandler: completion).resume()
    }
}
