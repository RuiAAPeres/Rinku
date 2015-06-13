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
public typealias FailureHandler = (Int, NSError?, NSData?) -> ()


struct RinkuNetworkTask : Equatable {
    
    let request : NSURLRequest
    var data : NSData
    
    private var progressHandlers : [ProgressHandler] = []
    private var failureHandlers : [FailureHandler] = []
    private var completionHandlers : [CompletionHandler] = []
    
    mutating func addProgressHandler(progressHandler : ProgressHandler) -> () {
        progressHandlers += [progressHandler]
    }
    
    mutating func addCompletionHandler(completionHandler : CompletionHandler) -> () {
        completionHandlers += [completionHandler]
    }
    
    mutating func addFailureHandler(failureHandler : FailureHandler) -> () {
        failureHandlers += [failureHandler]
    }
    
    func applyCompletionHandler() -> () {
        for handler in completionHandlers {
            handler(data)
        }
    }
    
    func applyFailureHandlers(statusCode: Int, error: NSError?, data: NSData?) -> () {
        for handler in failureHandlers {
            handler(statusCode, error, data)
        }
    }
    
    func applyProgressHandlers(progress : Double) {
        for handler in progressHandlers {
            handler(progress)
        }
    }
}

func == (lhs: RinkuNetworkTask, rhs: RinkuNetworkTask) -> Bool {
    return lhs.request.URL == rhs.request.URL
}
