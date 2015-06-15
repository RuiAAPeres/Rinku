//
//  RinkuNetworkTask.swift
//  Rinku
//
//  Created by Rui Peres on 12/06/2015.
//  Copyright (c) 2015 Rinku. All rights reserved.
//

import Foundation

public typealias CompletionHandler = (Int, NSData, NSError?) -> ()
public typealias ProgressHandler = Double -> ()

struct RinkuNetworkTask : Hashable {
    
    let request : NSURLRequest
    var data : NSMutableData = NSMutableData()
    
    var completionHandlers : [CompletionHandler] = []
    var progressHandlers : [ProgressHandler] = []
    
    init (request : NSURLRequest) {
        self.request = request
    }
    
    mutating func addHandlers(completion : CompletionHandler, progress : ProgressHandler) -> () {
       completionHandlers += [completion]
       progressHandlers += [progress]
    }
    
    func applyCompletionHandler(statusCode: Int, error: NSError?) -> () {
        for handler in completionHandlers {
            handler(statusCode,data, error)
        }
    }
    
    func applyProgressHandlers(progress : Double) {
        for handler in progressHandlers {
            handler(progress)
        }
    }
    
    var hashValue: Int {
        return (request.URL?.hashValue)!
    }
}

func == (lhs: RinkuNetworkTask, rhs: RinkuNetworkTask) -> Bool {
    return lhs.request.URL == rhs.request.URL
}








