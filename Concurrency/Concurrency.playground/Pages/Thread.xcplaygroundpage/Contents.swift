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


//: [Next](@next)
