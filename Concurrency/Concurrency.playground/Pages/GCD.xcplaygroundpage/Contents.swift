//: [Previous](@previous)

/*
 
 Link: https://theswiftdev.com/ultimate-grand-central-dispatch-tutorial-in-swift/
 
 - Note:
    -  DEADLOCK WARNING: you should never call sync on the main queue, because it'll cause a deadlock and a crash.
    - Don't call sync on a serial queue from the serial queue's thread!
    - Thread safety is all about avoiding messed up variable states
 
 - GCD:
    - Low-level C API
    - NSOperation -> Objective-C API
    - Synchronous tasks you'll block the execution queue.
        - Your function is most likely synchronous if it has a return value, so func load() -> String is going to probably block the thing that runs on until the resources is completely loaded and returned back.
    - With async tasks your call will instantly return and the queue can continue the execution of the remaining tasks.
        - Completion blocks are a good sing of async methods, for example if you look at this method func load(completion: (String) -> Void) you can see that it has no return type, but the result of the function is passed back to the caller later on through a block.
    - GCD organizes task into queues.
    - GCD executes tasks in FIFO order.
    - There are two types of dispatch queues:
        - Serial and concurrent queues
        -
    - The main queue is a serial one, every task on the main queue runs on the main thread.
    - Global queues are system provided concurrent queues shared through the operating system.
    - Custom queues can be created by the user.
 
- DispatchWorkItem:
    - DispatchWorkItem encapsulates work that can be performed. A work item can be dispatched onto a DispatchQueue and within a DispatchGroup. A DispatchWorkItem can also be set as a DispatchSource event, registration, or cancel handler.
 
 - DispatchGroup:
    - All of your long running background task can be executed concurrently, when everything is ready you'll receive a notification. Just be careful you have to use thread-safe data structures, so always modify arrays for example on the same thread
 
 - Semaphores:
    - A semaphore is simply a variable used to handle resource sharing in a concurrent system. It's a really powerful object.
 
 - DispatchSource:
    - A dispatch source is a fundamental data type that coordinates the processing of specific low-level system events.
 
 - Serial queues:
    - You can use a serial queue to enforce mutual exclusivity. All the tasks on the queue will run serially (in a FIFO order), only one process runs at a time and tasks have to wait for each other. One big downside of the solution is speed. 🐌
 
 - Concurrent queues using barriers:
    - You can send a barrier task to a queue if you provide an extra flag to the async method. If a task like this arrives to the queue it'll ensure that nothing else will be executed until the barrier task have finished.
 
*/


import Foundation
import Dispatch

/*

extension Date {
    static func showCurrentTime() -> String {
        // 1. Choose a date
        let today = Date()
        // 2. Pick the date components
        let hours   = (Calendar.current.component(.hour, from: today))
        let minutes = (Calendar.current.component(.minute, from: today))
        let seconds = (Calendar.current.component(.second, from: today))
        
        // 3. Return the time
        return "\(hours):\(minutes):\(seconds)"
    }
}
 
 */

// MARK: - Types of Queues

/*

DispatchQueue.main
DispatchQueue.global(qos: .userInitiated)
DispatchQueue.global(qos: .userInteractive)
DispatchQueue.global(qos: .background)
DispatchQueue.global(qos: .default)
DispatchQueue.global(qos: .utility)
DispatchQueue.global(qos: .unspecified)
DispatchQueue(label: "com.theswiftdev.queues.serial")
DispatchQueue(label: "com.theswiftdev.queues.concurrent", attributes: .concurrent)

*/

// MARK: - Switching b/w Queues

/*

DispatchQueue.global(qos: .background).async {
    // do your job here

    DispatchQueue.main.async {
        // update ui here
    }
}

 */
 
// MARK: - Sync and async calls on queues

/*

let q = DispatchQueue.global()

let text = q.sync {
    return "this will block"
}
print(text)

q.async {
    print("this will return instantly")
}

 */

// MARK: - Delay execution

/*

print("Hello at \(Date.showCurrentTime())")

DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
    //this code will be executed only after 2 seconds have been passed
    print("Hello at \(Date.showCurrentTime())")
}
 
 */

// MARK: - Debugging

// Do not use in production code!!!

/*

extension DispatchQueue {
    static var currentLabel: String {
        return String(validatingUTF8: __dispatch_queue_get_label(nil))!
    }
}
 
 */

// MARK: - Perform concurrent loop

/*

print(DispatchQueue.currentLabel)

DispatchQueue.concurrentPerform(iterations: 5) { (i) in
    print(i, Thread.isMainThread, DispatchQueue.currentLabel)
}

print(DispatchQueue.currentLabel)
 
 */

// MARK: - DispatchWorkItem

/*

var workItem: DispatchWorkItem?
workItem = DispatchWorkItem {
    for i in 1..<6 {
        guard let item = workItem, !item.isCancelled else {
            print("cancelled")
            
            break
        }
        
        sleep(1)
        
        print(String(i))
    }
}

print("Start at \(Date.showCurrentTime())")

workItem?.notify(queue: .main) {
    print("done")
}

DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(2)) {
    print("Cancel at \(Date.showCurrentTime())")
    workItem?.cancel()
}

DispatchQueue.main.async(execute: workItem!)

// you can use perform to run on the current queue instead of queue.async(execute:)
//workItem?.perform()

print("End at \(Date.showCurrentTime())")

*/

// MARK: - Concurrent tasks with DispatchGroups

/*

// Example 1

/*

func load(delay: UInt32, completion: () -> Void) {
    sleep(delay)
    completion()
}

let group = DispatchGroup()

print("Start at \(Date.showCurrentTime())")

group.enter()
load(delay: 1) {
    print("1")
    group.leave()
}

group.enter()
load(delay: 2) {
    print("2")
    group.leave()
}

group.enter()
load(delay: 3) {
    print("3")
    group.leave()
}

group.notify(queue: .main) {
    print("End at \(Date.showCurrentTime())")
    print("done")
}

 */

// Example 2

/*

let group = DispatchGroup()
let queue = DispatchQueue(label: "com.theswiftdev.queues.serial")
let workItem = DispatchWorkItem {
    print("start")
    sleep(1)
    print("end")
}

queue.async(group: group) {
    print("group start")
    sleep(2)
    print("group end")
}
DispatchQueue.global().async(group: group, execute: workItem)

// you can block your current queue and wait until the group is ready
// a better way is to use a notification block instead of blocking
//group.wait(timeout: .now() + .seconds(3))
//print("done")

group.notify(queue: .main) {
    print("done")
}

 */

// Example 3

/*

let queue = DispatchQueue.global()
let group = DispatchGroup()
let n = 9
print("Start at \(Date.showCurrentTime())")
for i in 0..<n {
    queue.async(group: group) {
        print("\(i): Running async task...")
        sleep(3)
        print("\(i): Async task completed")
    }
}

//group.wait()
//print("End at \(Date.showCurrentTime())")
//print("done")

group.notify(queue: .main) {
    print("End at \(Date.showCurrentTime())")
    print("done")
}

print("Middle at \(Date.showCurrentTime()), isMainThread: \(Thread.isMainThread)")

 */

 */

// MARK: - Semaphores

/*

// Usecase 1: How to make an async task to synchronous?
// Answer -> The answer is simple, you can use a semaphore (bonus point for timeouts)!

/*

enum DispatchError: Error {
    case timeout
}

func asyncMethod(completion: (String) -> Void) {
    sleep(2)
    completion("done")
}

func syncMethod() throws -> String {

    let semaphore = DispatchSemaphore(value: 0)
    let queue = DispatchQueue.global()
    
    print("Start at \(Date.showCurrentTime())")

    var response: String?
    queue.async {
        asyncMethod { r in
            response = r
            semaphore.signal()
        }
    }
    
    semaphore.wait(timeout: .now() + 5)
    
    print("End at \(Date.showCurrentTime())")
    
    guard let result = response else {
        throw DispatchError.timeout
    }
    
    return result
}

do {
    let response = try syncMethod()
    print(response)
} catch {
    dump(error)
}

 */

// Usecase 2: Lock / single access to a resource

// If you want to avoid race condition you are probably going to use mutual exclusion. This could be achieved using a semaphore object, but if your object needs heavy reading capability you should consider a dispatch barrier based solution.

/*

class LockedNumbers {

    let semaphore = DispatchSemaphore(value: 1)
    var elements: [Int] = []

    func append(_ num: Int) {
        self.semaphore.wait(timeout: DispatchTime.distantFuture)
        print("appended: \(num) at \(Date.showCurrentTime())")
        self.elements.append(num)
        self.semaphore.signal()
    }

    func removeLast() {
        self.semaphore.wait(timeout: DispatchTime.distantFuture)
        defer {
            self.semaphore.signal()
        }
        guard !self.elements.isEmpty else {
            return
        }
        let num = self.elements.removeLast()
        print("removed: \(num) at \(Date.showCurrentTime())")
    }
}

let items = LockedNumbers()
items.append(1)
items.append(2)
items.append(5)
items.append(3)
items.removeLast()
items.removeLast()
items.append(3)
print(items.elements)

 */

// Usecase 3: Wait for multiple tasks to complete

/*

let semaphore = DispatchSemaphore(value: 0)
let queue = DispatchQueue.global()
let n = 9

for i in 0..<n {
    queue.async {
        print("run \(i) at \(Date.showCurrentTime())")
        sleep(3)
        semaphore.signal()
    }
}

print("wait at \(Date.showCurrentTime())")

for i in 0..<n {
    semaphore.wait()
    print("completed \(i) at \(Date.showCurrentTime())")
}

print("done at \(Date.showCurrentTime())")
 
 */

// Usecase 4: Batch execution using a semaphore

// You can create a thread pool like behavior to simulate limited resources using a dispatch semaphore. So for example if you want to download lots of images from a server you can run a batch of x every time.

/*

print("start at \(Date.showCurrentTime())")

let sem = DispatchSemaphore(value: 5)
for i in 0..<10 {
    DispatchQueue.global().async {
        sem.wait()
        print("\(i) before sleep \(Date.showCurrentTime())")
        sleep(2)
        print("\(i) after sleep \(Date.showCurrentTime())")
        sem.signal()
    }
}

print("end at \(Date.showCurrentTime())")
 
 */
 
 */

// MARK: - DispatchSource

/*

let timer = DispatchSource.makeTimerSource()
timer.schedule(deadline: .now(), repeating: .seconds(1))
timer.setEventHandler {
    print("hello at \(Date.showCurrentTime())")
}
timer.resume()
 
 */

// MARK: - Thread-safety using the dispatch framework

/*

let t = Thread {
    print(Thread.current.name ?? "")
     let timer = Timer(timeInterval: 1, repeats: true) { t in
         print("tick")
     }
    RunLoop.current.add(timer, forMode: RunLoop.Mode.default)

    RunLoop.current.run()
    RunLoop.current.run(mode: RunLoop.Mode.common, before: Date.distantPast)
}
t.name = "my-thread"
t.start()

*/

// MARK: - Serial queues

/*

let q = DispatchQueue(label: "com.theswiftdev.queues.serial")
var evenNumbers = [2, 4, 6, 8, 10]

q.async() {
  // writes
    evenNumbers.append(10)
    evenNumbers.append(12)
    dump(evenNumbers)
    print(Thread.isMainThread)
}

q.sync() {
  // reads
    dump(evenNumbers.first)
    print(Thread.isMainThread)
}

print(Thread.isMainThread)
 
 */

// MARK: - Concurrent queues using barriers

/*

let q = DispatchQueue(label: "com.theswiftdev.queues.concurrent", attributes: .concurrent)
var evenNumbers = [2, 4, 6, 8, 10]

q.async(flags: .barrier) {
  // writes
    evenNumbers.append(10)
    evenNumbers.append(12)
    dump(evenNumbers)
    print(Thread.isMainThread)
}

q.sync() {
  // reads
    dump(evenNumbers.first)
    print(Thread.isMainThread)
}

print(Thread.isMainThread)
 
 */

// MARK: - A few anti-patterns

/*

let queue = DispatchQueue(label: "com.theswiftdev.queues.serial")

queue.sync {
    // do some sync work
    print(Thread.isMainThread)
    queue.sync {
        // this won't be executed -> deadlock!
        print(Thread.isMainThread)
    }
}

//What you are trying to do here is to launch the main thread synchronously from a background thread before it exits. This is a logical error.
//https://stackoverflow.com/questions/49258413/dispatchqueue-crashing-with-main-sync-in-swift?rq=1
DispatchQueue.global(qos: .utility).sync {
    // do some background task
    print(Thread.isMainThread)
    
    DispatchQueue.main.sync {
        // app will crash
        print(Thread.isMainThread)
    }
}

 */

//: [Next](@next)
