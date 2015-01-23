//
//  Rinku.swift
//  Rinku
//
//  Created by Rui Peres on 12/06/2014.
//  Edit by Alexander Li on 01/23/2015.
//  Copyright (c) 2014 Aphely. All rights reserved.
//

import Foundation

let RinkuPost : String = "POST"
let RinkuGet : String = "GET"

/**
*  Http Lib
*/
class Rinku {

    let request : NSMutableURLRequest

    /**
    init request
    :param: httpMethod  httpMethod String
    :param: endpointURL endpointURL String
    :param: httpHeaders http headers Dictionary

    :returns: Http Lib Object
    */
    init(httpMethod: String, endpointURL : String, httpHeaders : Dictionary<String, String>?) {

        let url = NSURL(string: endpointURL)
        request =  NSMutableURLRequest(URL: url!)
        request.HTTPMethod = httpMethod

        if let httpHeadersUnWrapped = httpHeaders {
            request.allHTTPHeaderFields = httpHeadersUnWrapped
        }
    }

    // Class Methods
    /**
    Factory method to create a Rinku object to make http post request

    :param: url url String

    :returns: Rinku Object it self
    */
    class func post(url :String) -> Rinku {
        return Rinku(httpMethod: RinkuPost, endpointURL: url, httpHeaders: nil)
    }

    /**
    Factory method to create a Rinku object to make http post request

    :param: url url String

    :returns: Rinku Object it self
    */
    class func get(url :String) -> Rinku {
        return Rinku(httpMethod: RinkuGet, endpointURL: url, httpHeaders: nil)
    }

    // Instance Methods

    /**
    Set http headers

    :param: headers headers Dictionary

    :returns: Rinku Object it self
    */
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

    /**
    Set Http body

    :param: httpBody HttpBody Raw data NSData

    :returns: Rinku Object it self
    */
    func body(httpBody : NSData) -> Rinku {
        request.HTTPBody = httpBody
        return self
    }

    /**
    Set Post data

    :param: dict data Dictionary

    :returns: Rinku Object it self
    */
    func form(dict: Dictionary<String,String>) -> Rinku{
        let postData:NSData = prepareForm(dict)
        request.setValue("application/x-www-form-urlencoded;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("\(postData.length)", forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postData
        return self
    }

    /**
    Set json string as Httpbody

    :param: jsonString json String

    :returns: Rinku Object it self
    */
    func json(jsonString:String) -> Rinku{
        let postData:NSData = jsonString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)!
        request.setValue("\(postData.length)", forHTTPHeaderField: "Content-Length")
        request.HTTPBody = postData
        return self
    }

    /**
    Set request timeout

    :param: duration timeout duration NSTimeInterval

    :returns: Rinku Object it self
    */
    func timeout(duration:NSTimeInterval) -> Rinku{
        request.timeoutInterval = duration
        return self
    }

    /**
    Set post file

    :param: fileData  file data NSData
    :param: filefield file data fieldname String
    :param: filename  filename String
    :param: extForm   form data Dictionary

    :returns: Rinku Object it self
    */
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

    /**
    Set completion callback and start task

    :param: completion completion callback with NSData NSURLResponse and NSError
    */
    func completion(completion : (NSData!, NSURLResponse!, NSError!) -> ()) -> () {

        var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil
            , delegateQueue: NSOperationQueue.mainQueue())

        session.dataTaskWithRequest(self.request, completionHandler: completion).resume()
    }

    /**
    Set completion callback with json data and start task

    :param: completion completion callback with AnyObject(Dictionary or Array) NSURLResponse and NSError
    */
    func completionJsonify(completion: (AnyObject!, NSURLResponse!, NSError!) -> ()) -> (){
        var session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: nil
            , delegateQueue: NSOperationQueue.mainQueue())
        var completionDelegate:(NSData!, NSURLResponse!, NSError!) -> () = { (data, response, error) -> () in
            var jsonError:NSError?
            let jsonObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &jsonError)
            if (jsonError != nil){
                completion(nil, response, jsonError)
                return
            }
            completion(jsonObject!, response, error)
            return
        }
        session.dataTaskWithRequest(self.request, completionHandler: completionDelegate).resume()
    }


    /**
    Make random string for boundary

    :returns: random string
    */
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

    /**
    Prepare form data in httpbody

    :param: dict form data dictionary

    :returns: form data NSData
    */
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
