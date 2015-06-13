//
//  RinkuResource.swift
//  Rinku
//
//  Created by Rui Peres on 12/06/2015.
//  Copyright © 2015 Rinku. All rights reserved.
//

import XCTest
@testable import Rinku

class RinkuResource: XCTestCase {

    func testEquality() {
        
        let r1 = RinkuResource(path: "", method: .POST, body: nil, header: nil)
        let r2 = RinkuResource(path: "", method: .POST, body: nil, header: nil)
        
        XCTAssert(r1 == r2)
    }
    
    func testEqualityDifferentPath() {
        
        let r1 = RinkuResource(path: "r1", method: .POST, body: nil, header: nil)
        let r2 = RinkuResource(path: "r2", method: .POST, body: nil, header: nil)
        
        XCTAssert(r1 != r2)
    }
}
