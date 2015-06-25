//
//  RinkuDelegateTests.swift
//  Rinku
//
//  Created by Rui Peres on 24/06/2015.
//  Copyright © 2015 Rinku. All rights reserved.
//

import XCTest
@testable import Rinku


class RinkuDelegateTests: XCTestCase {
    
    private static func rinkuDelegate() -> RinkuDelegate {
        return RinkuDelegate()
    }
    
    private static func session<T : NSURLSessionDataDelegate>(delegate : T) -> NSURLSession {
        return NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: delegate, delegateQueue: nil)
    }
    
    func testRequest() {
        
        let rinku = RinkuDelegateTests.rinkuDelegate()
        let session = RinkuDelegateTests.session(rinku)
        
        
        session.dat
        
    }

}
