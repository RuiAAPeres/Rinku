//
//  RinkuResourceTests.swift
//  Rinku
//
//  Created by Rui Peres on 12/06/2015.
//  Copyright © 2015 Rinku. All rights reserved.
//

import XCTest
@testable import Rinku

class RinkuResourceTests: XCTestCase {
    
    func testDescription() {
        
        let r = RinkuResource(path: "r", method: .POST, body: nil, header: nil)
        
        XCTAssert(r.description == "Path:r\nMethod:POST\n")
    }

    func testEquality() {
        
        let r1 = RinkuResource(path: "r", method: .POST, body: nil, header: nil)
        let r2 = RinkuResource(path: "r", method: .POST, body: nil, header: nil)
        
        XCTAssert(r1 == r2)
    }
    
    func testEqualityDifferentPath() {
        
        let r1 = RinkuResource(path: "r1", method: .POST, body: nil, header: nil)
        let r2 = RinkuResource(path: "2", method: .POST, body: nil, header: nil)
        
        XCTAssert(r1 != r2)
    }
    
    func testEqualityDifferentMethod() {
        
        let r1 = RinkuResource(path: "r", method: .POST, body: nil, header: nil)
        let r2 = RinkuResource(path: "r", method: .GET, body: nil, header: nil)
        
        XCTAssert(r1 != r2)
    }
    
    func testEqualityDifferentBody() {
        
        do {
            let r1 = RinkuResource(path: "r", method: .POST, body: NSData(), header: nil)
            let r2 = RinkuResource(path: "r", method: .POST, body: nil, header: nil)
            
            XCTAssert(r1 != r2)
        }

        do {
            let r1 = RinkuResource(path: "r", method: .POST, body: nil, header: nil)
            let r2 = RinkuResource(path: "r", method: .POST, body: NSData(), header: nil)
            
            XCTAssert(r1 != r2)
        }
    }
    
    func testEqualityDifferentBodyWithDifferenData() {
        
        let r1Data = "Hello World".dataUsingEncoding(NSUTF8StringEncoding)
        let r2Data = "Foo Bar".dataUsingEncoding(NSUTF8StringEncoding)

        let r1 = RinkuResource(path: "r", method: .POST, body: r1Data, header: nil)
        let r2 = RinkuResource(path: "r", method: .POST, body: r2Data, header: nil)
        
        XCTAssert(r1 != r2)
    }
    
    func testEqualityEqualBodyWithEqualData() {
        
        let rData = "Hello World".dataUsingEncoding(NSUTF8StringEncoding)
        
        let r1 = RinkuResource(path: "r", method: .POST, body: rData, header: nil)
        let r2 = RinkuResource(path: "r", method: .POST, body: rData, header: nil)
        
        XCTAssert(r1 == r2)
    }
}
