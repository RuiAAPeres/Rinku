//
//  RinkuResource.swift
//  Rinku
//
//  Created by Rui Peres on 12/06/2015.
//  Copyright (c) 2015 Rinku. All rights reserved.
//

import Foundation

public typealias Header = [String : String]

public struct RinkuResource : Equatable, CustomStringConvertible {
    
    let path : String
    let method : Method
    let body : NSData?
    let header : Header?
    
    public init(path : String, method : Method, body : NSData?, header : Header?) {
        self.path = path
        self.method = method
        self.body = body
        self.header = header
    }
    
    public var description : String {
        return "Path:\(path)\nMethod:\(method.rawValue)\n"
    }
}

public func == (lhs: RinkuResource, rhs: RinkuResource) -> Bool {
    
    var equalBody = false
    
    switch (lhs.body, rhs.body) {
        case (nil,nil): equalBody = true
        case (nil,_?) : equalBody = false
        case (_?,nil) : equalBody = false
        case (let l?,let r?) : equalBody = l.isEqualToData(r)
    }
    
    return (lhs.path == rhs.path && lhs.method == rhs.method && equalBody)
}
