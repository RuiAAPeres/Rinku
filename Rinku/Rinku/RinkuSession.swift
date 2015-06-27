//
//  RinkuSession.swift
//  Rinku
//
//  Created by Rui Peres on 25/06/2015.
//  Copyright © 2015 Rinku. All rights reserved.
//

import Foundation

class RinkuSession {
    
    let session : NSURLSession
    let rinkuDelegate = RinkuDelegate()
    
    init (configuration : NSURLSessionConfiguration = NSURLSessionConfiguration.defaultSessionConfiguration()) {
        self.session = NSURLSession(configuration: configuration, delegate: self.rinkuDelegate, delegateQueue: NSOperationQueue.mainQueue())
    }
    
    deinit {
        self.session.invalidateAndCancel()
    }
}
