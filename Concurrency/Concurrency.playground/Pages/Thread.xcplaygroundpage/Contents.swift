//: [Previous](@previous)

/*
 
 Link:
    - https://stevenpcurtis.medium.com/which-thread-are-you-using-in-swift-dd01d6182e6c
 
 - Threads:
    - A context in which commands are executed.
    -
 
 - GCD:
    - Manages a collection of Dispatch Queues
    - Work is executed on pool of threads.
    - Operates at system level.
    
    - Dispatch Queues:
        - A Dispatch Queues is a queue onto which work can be scheduled for execution.
        - 2 types of Dispatch Queues:
            - Serial:
                - Executes tasks in a predictable order.
                - Less performant.
            - Concurrent
                - Executes tasks in a Unpredictable/ Paralell order.
                - More performant.
        - Every app has access to Main Queue and several background queues.
*/


import Foundation

/*
extension Thread {
    var threadName: String {
        if let currentOperationQueue = OperationQueue.current?.name {
            return "OperationQueue: \(currentOperationQueue)"
        } else if let underlyingDispatchQueue = OperationQueue.current?.underlyingQueue?.label {
            return "DispatchQueue: \(underlyingDispatchQueue)"
        } else {
            let name = __dispatch_queue_get_label(nil)
            return String(cString: name, encoding: .utf8) ?? Thread.current.description
        }
    }
}

print(Thread().threadName)
DispatchQueue.global(qos: .background).async {
    print(Thread().threadName)
}
 */

// MARK: - 1.) What is a Thread?

/*
 - Create a new Xcode project and pause execution.
 - Show all the available threads.
 */

// MARK: - 2.) How to create a Thread?

class SomeApp {
    var thread: Thread?
    
    func createThread() {
        thread = Thread(target: self, selector: #selector(fetchData),  object: nil)
                                    
        thread?.start()
    }
    
    func cancelThread() {
        thread?.cancel()
    }
    
    @objc func fetchData() {
        dump("Custom thread in action")
    }
}

let customThread = SomeApp()
customThread.createThread()
print(customThread.thread?.isExecuting, customThread.thread?.isFinished, customThread.thread?.isCancelled)
customThread.cancelThread()
print(customThread.thread?.isExecuting, customThread.thread?.isFinished, customThread.thread?.isCancelled)

// MARK: - 3.) Why do we need Threads?

/*
 - Threads are an essential tool for improving the performance, responsiveness, and overall user experience of iOS applications. They help you achieve concurrency, parallelism, and background processing, all of which are crucial for modern mobile applications.
 - Run Main Thread App & Show Main Thread v/s Background Thread example.
 - Run Instruments -> Animation Hitches and Time Profiler to show the performance difference.
 */

// MARK: - 4.) How do we manage Threads => Multi Threading/ Concurrency

/*
 - Creating and managing threads manually.
 - Using GCD (Grand Central Dispatch).
 - Operations and queues (NSOperation).
 - Combine
 - Async Await.
 */

// MARK: - 5.) Using GCD (Grand Central Dispatch)

/*
 - Switch to GCD playground page
 */

//: [Next](@next)
