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
 - A processor can run tasks made by you programmatically, this is usually called coding, developing or programming. The code executed by a CPU core is a thread. So your app is going to create a process that is made up from threads. 🤓
 - In the past a processor had one single core, it could only deal with one task at a time. Later on time-slicing was introduced, so CPU's could execute threads concurrently using context switching. As time passed by processors gained more horse power and cores so they were capable of real multi-tasking using parallelism. ⏱
 - 1 core == ~ 2 threads.
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

// MARK: - 3.) Why do we need Multi Threading?

/*
 - Multithreading is a pattern to increase the performance of an application.
 - By scheduling work on multiple threads, more work can be performed in parallel.
 - Performing work in parallel is also known as concurrency.
 - Multithreading and concurrency have gained in importance over the years because devices have transitioned from having a single processor with a single core to one or more processors with multiple cores.
 - Run Main Thread App & Show Main Thread v/s Background Thread example.
 - Run Instruments -> Animation Hitches and Time Profiler to show the performance difference.
 */

// MARK: - 4.) - How many threads can an app get/ have in iOS ?

/*
 - Every Cocoa application has a minimum of one thread, the main thread. The main thread is the thread on which the application starts its life.
     - Main Thread
 - NO specific limit, minimum 2
 */

// MARK: - 5.) What is Main Thread?

/*
 - In iOS, primary thread on which process is started is commonly called as Main thread
 */

print(Thread.isMainThread)

DispatchQueue.global().async {
    print(Thread.isMainThread)
}


// MARK: - 6.) How do we manage Threads => Multi Threading/ Concurrency

/*
 - Creating and managing threads manually.
 - Using GCD (Grand Central Dispatch).
 - Operations and queues (NSOperation).
 - Combine
 - Async Await.
 */

// MARK: - 7.) Using GCD (Grand Central Dispatch)

/*
 - Switch to GCD playground page
 */

//: [Next](@next)
