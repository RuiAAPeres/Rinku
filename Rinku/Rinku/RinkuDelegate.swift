//
//  RinkuDelegate.swift
//  Rinku
//
//  Created by Rui Peres on 12/06/2015.
//  Copyright © 2015 Rinku. All rights reserved.
//

import Foundation

public class RinkuDelegate : NSObject,  NSURLSessionDataDelegate {
    
    private var tasks: Set<RinkuNetworkTask> = Set()
    
    public func addRequest(request : NSURLRequest, completion : CompletionHandler, progress : ProgressHandler? {
        
        var task = self.taskForRequest(request)
        
        if task == nil {
            task = RinkuNetworkTask(url: request.URL!)
            self.tasks.insert(task)
        }

        task.addHandlers(completion, progress: progress)
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
        return tasks.filter { task in task.url == request?.URL! }.first
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
