//
//  RinkuResource.swift
//  Rinku
//
//  Created by Rui Peres on 12/06/2014.
//  Edit by Alexander Li on 12/23/2014.
//  Copyright (c) 2014 Aphely. All rights reserved.
//

import Foundation

typealias Header = [String : String]

public struct RinkuResource : CustomStringConvertible {
    
    let path : String
    let method : Method
    let body : NSData?
    let header : Header
    
    public var description : String {
        return "Path:\(path)\nMethod:\(method.rawValue)\n"
    }
}
