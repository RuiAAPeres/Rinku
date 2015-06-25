//
//  RinkuNetworkingTaskTests.swift
//  Rinku
//
//  Created by Rui Peres on 23/06/2015.
//  Copyright © 2015 Rinku. All rights reserved.
//

import XCTest
@testable import Rinku

let kGoogle = "www.google.com"
let kYahoo = "www.yahoo.com"

class RinkuNetworkingTaskTests: XCTestCase {
    
    func testEqualityShouldSucceedForSameURL() {
        
        let task1 = RinkuNetworkTask(url: NSURL(string: kGoogle)!)
        let task2 = RinkuNetworkTask(url: NSURL(string: kGoogle)!)
        
        XCTAssertEqual(task1, task2)
    }
    
    func testEqualityShouldFailForDifferentURL() {
        
        let task1 = RinkuNetworkTask(url: NSURL(string: kGoogle)!)
        let task2 = RinkuNetworkTask(url: NSURL(string: kYahoo)!)
        
        XCTAssertNotEqual(task1, task2)
    }
    
    func testHashabilityOnURL() {
        
        let task1 = RinkuNetworkTask(url: NSURL(string: kGoogle)!)
        let task2 = RinkuNetworkTask(url: NSURL(string: kGoogle)!)
        let task3 = RinkuNetworkTask(url: NSURL(string: kYahoo)!)
        
        var uniqueTasks : Set<RinkuNetworkTask> = Set(arrayLiteral: task1,task2)
        XCTAssert(uniqueTasks.count == 1)
        
        
        uniqueTasks.insert(task3)
        XCTAssert(uniqueTasks.count == 2)
    }
    
    func testAddHandlers() {
        var task = RinkuNetworkTask(url: NSURL(string: kGoogle)!)
        
        let completionHandler : CompletionHandler = { (status, data , error) in }
        let progressHandler : ProgressHandler = { (progress) in }

        task.addHandlers(completionHandler, progress: progressHandler)
        task.addHandlers(completionHandler, progress: progressHandler)
        task.addHandlers(completionHandler, progress: progressHandler)
        
        XCTAssert(task.completionHandlers.count == 3)
        XCTAssert(task.progressHandlers.count == 3)

    }
    
    func testCompletionHandlers() {
        var numberOfCompletions = 0
        let expectation = expectationWithDescription("Completion Expectation")
        
        var task = RinkuNetworkTask(url: NSURL(string: kGoogle)!)
        
        let completionHandler : CompletionHandler = { (status, data, error) -> () in
            
            XCTAssert(status == 200)
            XCTAssert(error == nil)
            XCTAssert(data.length == 0)
            
            if ((++numberOfCompletions) == 3) {
                expectation.fulfill()
            }
        }
        
        task.addHandlers(completionHandler,progress: nil)
        task.addHandlers(completionHandler,progress: nil)
        task.addHandlers(completionHandler,progress:nil)
        
        task.applyCompletionHandler(200, error: nil)

        waitForExpectationsWithTimeout(1, handler: nil)
    }
    
    func testProgressHandlers() {
        var numberOfCompletions = 0
        let expectation = expectationWithDescription("Completion Expectation")
        
        var task = RinkuNetworkTask(url: NSURL(string: kGoogle)!)
        
        let completionHandler : CompletionHandler = { (status, data , error) in }
        let progressHandler : ProgressHandler = { (progress) in
            
            if ((++numberOfCompletions) == 51 * task.progressHandlers.count) {
                expectation.fulfill()
            }
        }
        
        task.addHandlers(completionHandler, progress: progressHandler)
        task.addHandlers(completionHandler, progress: progressHandler)
        task.addHandlers(completionHandler, progress: progressHandler)
        
        for i in 0...100 where i % 2 == 0 {
            task.applyProgressHandlers(Double(i))
        }
        
        waitForExpectationsWithTimeout(1, handler: nil)
    }
}
