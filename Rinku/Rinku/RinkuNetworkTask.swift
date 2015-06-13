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
public typealias FailureHandler = (statusCode: Int, error: NSError?, data: NSData?) -> ()


struct RinkuNetworkTask {
    
    let request : NSURLRequest
    var data : NSData
    
    
    private var progressHandlers : [ProgressHandler] = []
    private var failureHandlers : [FailureHandler] = []
    private var completionHandlers : [CompletionHandler] = []
    
    mutating func addProgressHandler(progressHandler : ProgressHandler) -> () {
        self.progressHandlers += [progressHandler]
    }
    
    mutating func addCompletionHandler(completionHandler : CompletionHandler) -> () {
        self.completionHandlers += [completionHandler]
    }
    
    mutating func addFailureHandler(failureHandler : FailureHandler) -> () {
        self.failureHandlers += [failureHandler]
    }
    
    
    func applyCompletionHandler() -> () {
        self.completionHandlers.map { handler in
            handler(data)
        }
    }
}