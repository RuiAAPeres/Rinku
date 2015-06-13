//
//  RinkuNetworkTask.swift
//  Rinku
//
//  Created by Rui Peres on 12/06/2015.
//  Copyright (c) 2015 Rinku. All rights reserved.
//

import Foundation

public typealias CompletionHandler = NSData -> ()
public typealias ProgressHandler = Double -> ()
public typealias FailureHandler = (Int, NSError?, NSData) -> ()


struct RinkuNetworkTask : Hashable {
    
    let request : NSURLRequest
    var data : NSMutableData = NSMutableData()
    
    private var completionHandlers : [CompletionHandler] = []
    private var failureHandlers : [FailureHandler] = []
    private var progressHandlers : [ProgressHandler] = []

    
    init(request : NSURLRequest, completion : CompletionHandler, failure : FailureHandler, progress : ProgressHandler) {
        self.request = request
        
        self.completionHandlers = [completion]
        self.failureHandlers = [failure]
        self.progressHandlers = [progress]
    }
    
    mutating func addHandlers(completion : CompletionHandler, failure : FailureHandler, progress : ProgressHandler) -> () {
        completionHandlers += [completion]
        failureHandlers += [failure]
        progressHandlers += [progress]
    }
    
    func applyCompletionHandler() -> () {
        for handler in completionHandlers {
            handler(data)
        }
    }
    
    func applyFailureHandlers(statusCode: Int, error: NSError?) -> () {
        for handler in failureHandlers {
            handler(statusCode, error, data)
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
