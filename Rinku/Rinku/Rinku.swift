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

class Rinku {
    
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
    
    class func post(url :String) -> Rinku {
        return Rinku(httpMethod: RinkuPost, endpointURL: url, httpHeaders: nil)
    }
    
    class func get(url :String) -> Rinku {
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

    func form(dict: Dictionary<String,String>) -> Rinku{
        let postData:NSData = prepareForm(dict)
        request.setValue("application/x-www-form-urlencoded;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("\(postData.length)", forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postData
        return self
    }

    func json(jsonString:String) -> Rinku{
        let postData:NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        request.setValue("\(postData.length)", forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postData
        return self
    }

    func file(fileData:NSData,filefield:String, filename:String, extForm:Dictionary<String,String>) -> Rinku{
        let boundary:String = "---------------------------\(randStr())"
        let contentType:String = "multipart/form-data; boundary=\(boundary)"
        request.setValue(contentType, forHTTPHeaderField: "Content-Type")
        let postData:NSMutableData = NSMutableData()
        postData.appendData("\r\n--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)

        for (field, value) in extForm{
            //Content-Disposition: form-data; name=\"message\"\r\n\r\n%@
            postData.appendData("Content-Disposition: form-data; name=\"\(field)\"\r\n\r\n\(value)".dataUsingEncoding(NSUTF8StringEncoding)!)
            postData.appendData("\r\n--\(boundary)\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        }

        postData.appendData("Content-Disposition: form-data; name=\"\(filefield)\"; filename=\"\(filename)\"\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        postData.appendData("Content-Type: application/octet-stream\r\n\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)
        postData.appendData(fileData)
        postData.appendData("\r\n--\(boundary)--\r\n".dataUsingEncoding(NSUTF8StringEncoding)!)


        request.setValue("\(postData.length)", forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postData
        return self
    }

    func completion(completion : (NSData!, NSURLResponse!, NSError!) -> ()) -> () {
        
        var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil
            , delegateQueue: NSOperationQueue.mainQueue())
        
       session.dataTaskWithRequest(self.request, completionHandler: completion).resume()
    }

    private func randStr()->String{
        let pool:String = "qazxswedcvfrtgbnhyujmkiolp0987654321"
        let poolArr:Array = Array(pool)
        let tmp:NSMutableArray = NSMutableArray(capacity: 10)
        for idx in 0...10{
            let random:Int = Int(arc4random_uniform(36))
            tmp.addObject(String(poolArr[random]))
        }
        return tmp.componentsJoinedByString("")
    }

    private func prepareForm(dict: Dictionary<String,String>) ->NSData{
        let frames:NSMutableArray = NSMutableArray()
        for (key, value) in dict{
            let encodedString:String = value.stringByAddingPercentEncodingWithAllowedCharacters(.URLFragmentAllowedCharacterSet())!
            frames.addObject(("\(key)=\(encodedString)"))
        }
        let postData:NSData = frames.componentsJoinedByString("&").dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        return postData
    }

}
