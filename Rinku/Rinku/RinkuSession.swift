//
//  RinkuSession.swift
//  Rinku
//
//  Created by Rui Peres on 12/06/2015.
//  Copyright © 2015 Rinku. All rights reserved.
//

import Foundation

public class RinkuSession : NSObject,  NSURLSessionDataDelegate {
    
    private var session: NSURLSession!
    private var tasks: Set<RinkuNetworkTask> = Set()
    
    public override init() {
        super.init()
        
        self.session = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration(), delegate: self, delegateQueue: nil)
    }
    
    deinit {
        session.invalidateAndCancel()
    }
    
    public func makeRequest(request : NSURLRequest, completion : CompletionHandler, progress : ProgressHandler = {double in }) -> () {
        
        var task = self.taskForRequest(request)
        
        if task == nil {
            task = RinkuNetworkTask(request: request)
            self.tasks.insert(task)
            session.dataTaskWithRequest(request)?.resume()
        }

        task.addHandlers(completion, progress: progress)
    }
    
    public func cancelAll() {
        session.getAllTasksWithCompletionHandler { tasks in
            self.cancelTasks(tasks)
        }
    }
    
    public func cancelRequest(request : NSURLRequest) {
        session.getAllTasksWithCompletionHandler { tasks in
            self.cancelTasks(tasks.filter { task in task.originalRequest == request })
        }
    }
    
    public func URLSession(session: NSURLSession, dataTask: NSURLSessionDataTask, didReceiveData data: NSData) {
        guard let rinkuTask = taskForRequest(dataTask.originalRequest) else { return }
        
        let totalBytesReceived = Int64(rinkuTask.data.length)
        let totalBytesExpectedToReceive = dataTask.response?.expectedContentLength ?? NSURLSessionTransferSizeUnknown

        rinkuTask.applyProgressHandlers(Double(totalBytesReceived) / Double(totalBytesExpectedToReceive))
        rinkuTask.data.appendData(data)
    }
    
     public func URLSession(session: NSURLSession, task: NSURLSessionTask, didCompleteWithError error: NSError?) {
        
        guard let rinkuTask = taskForRequest(task.originalRequest) else { return }
        removeTask(rinkuTask)
        
        var statusCode = 0
        if let task = task.response as? NSHTTPURLResponse {
            statusCode = task.statusCode
        }
        
        rinkuTask.applyCompletionHandler(statusCode, error: error)
    }
    
    private func taskForRequest(request : NSURLRequest?) -> RinkuNetworkTask! {
        return tasks.filter { task in task.request == request }.first
    }
    
    private func removeTask(task: RinkuNetworkTask) {
        tasks.remove(task)
    }
    
    private func cancelTasks(tasks : [NSURLSessionTask]) -> () {
        for task in tasks {
            task.cancel()
        }
    }

}
