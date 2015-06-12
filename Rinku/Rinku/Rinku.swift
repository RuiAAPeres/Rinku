//
//  Rinku.swift
//  Rinku
//
//  Created by Rui Peres on 12/06/2014.
//  Edit by Alexander Li on 12/23/2014.
//  Copyright (c) 2014 Aphely. All rights reserved.
//

import Foundation

let RinkuPost : String = "POST"
let RinkuGet : String = "GET"

struct Rinku {
    
    let request : NSMutableURLRequest
    
    init(httpMethod: String, endpointURL : String, httpHeaders : Dictionary<String, String>?) {
        
        let url = NSURL(string: endpointURL)
        request =  NSMutableURLRequest(URL: url!)
        request.HTTPMethod = httpMethod
        
        if let httpHeadersUnWrapped = httpHeaders {
            request.allHTTPHeaderFields = httpHeadersUnWrapped
        }
    }
    
    // Class Methods
    
    static func post(url :String) -> Rinku {
        return Rinku(httpMethod: RinkuPost, endpointURL: url, httpHeaders: nil)
    }
    
    static func get(url :String) -> Rinku {
        return Rinku(httpMethod: RinkuGet, endpointURL: url, httpHeaders: nil)
    }
    
    // Instance Methods
    
    func headers(headers : Dictionary<String,String>) ->Rinku {
        request.allHTTPHeaderFields = headers
        return self
    }
    
    func auth(username:String, password:String) ->Rinku{
        let authData:NSData = "\(username):\(password)".dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)!
        let authStr:String = "Basic \(authData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding76CharacterLineLength))"
        request.setValue(authStr, forHTTPHeaderField: "Authorization")
        return self
    }
    
    func body(httpBody : NSData) -> Rinku {
        request.HTTPBody = httpBody
        return self
    }
    
    func json(jsonString:String) -> Rinku{
        let postData:NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        request.setValue("\(postData.length)", forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postData
        return self
    }
    
    func completion(completion : (NSData?, NSURLResponse?, NSError?) -> ()) -> () {
        
        let session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil
            , delegateQueue: NSOperationQueue.mainQueue())
        
        session.dataTaskWithRequest(self.request, completionHandler: completion)!.resume()
    }
}
