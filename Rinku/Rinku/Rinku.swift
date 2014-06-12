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
    
    var httpBody : NSData!
    let request : NSMutableURLRequest
    
    
    init(httpMethod: String, endpointURL : String, httpHeaders : Dictionary<String, String>?) {
        
        let url = NSURL(string: endpointURL)
        self.request =  NSMutableURLRequest(URL: url)
        self.request.HTTPMethod = httpMethod
        
        if let httpHeadersUnWrapped = httpHeaders {
            self.request.allHTTPHeaderFields = httpHeadersUnWrapped
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
    
    func withHeaders(headers : Dictionary<String,String>) -> Rinku {
        self.request.allHTTPHeaderFields = headers
        return self
    }
    
    func withBody(httpBody : NSData) -> Rinku {
        self.request.HTTPBody = httpBody
        return self
    }

    func withCompletion(completion : (NSURLResponse!, NSData!, NSError!) -> ()) -> () {
        NSURLConnection.sendAsynchronousRequest(self.request, queue:
            NSOperationQueue(), completionHandler: completion)
    }
}
