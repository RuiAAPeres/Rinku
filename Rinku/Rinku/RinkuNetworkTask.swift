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
    let data : NSData
    
    let completionHandlers : [CompletionHandler]
    let progressHandlers : [ProgressHandler]

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


extension RinkuNetworkTask {
    
    func dataLens() -> Lens<RinkuNetworkTask, NSData> {
       return Lens(from:{$0.data }, to: { RinkuNetworkTask(request: $1.request, data: $0, completionHandlers: $1.completionHandlers, progressHandlers: $1.progressHandlers) } )
    }
    
    func completionLens() -> Lens<RinkuNetworkTask, [CompletionHandler]> {
        return Lens(from:{$0.completionHandlers}, to: { RinkuNetworkTask(request: $1.request, data: $1.data, completionHandlers: $0, progressHandlers: $1.progressHandlers) } )
    }
    
    func progressLens() -> Lens<RinkuNetworkTask, [ProgressHandler]> {
        return Lens(from:{$0.progressHandlers}, to: { RinkuNetworkTask(request: $1.request, data: $1.data, completionHandlers: $1.completionHandlers, progressHandlers: $0) } )
    }
}
