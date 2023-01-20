//: [Previous](@previous)

/*
 
 Link: https://theswiftdev.com/swift-actors-tutorial-a-beginners-guide-to-thread-safe-concurrency/
 
 - Actors:
    - First of all, actors are reference types, just like classes. They can have methods, properties, they can implement protocols, but they don't support inheritance.
    - Since actors are closely realted to the newly introduced async/await concurrency APIs in Swift you should be familiar with that concept too if you want to understand how they work.
 
*/

import Foundation
import Dispatch

// MARK: - Thread safety & data races

/*

var unsafeNumber: Int = 0
DispatchQueue.concurrentPerform(iterations: 100) { i in
    print(Thread.current)
    unsafeNumber = i
}
print(unsafeNumber)
 
 */

// Problem: Race Condition

/*

var threads: [Int: String] = [:]
DispatchQueue.concurrentPerform(iterations: 100) { i in
    threads[i] = "\(Thread.current)"
}
print(threads)
 
 */

// Solution 1: Serial Queue

/*

var threads: [Int: String] = [:]
let lockQueue = DispatchQueue(label: "my.serial.lock.queue")
DispatchQueue.concurrentPerform(iterations: 100) { i in
    lockQueue.sync {
        threads[i] = "\(Thread.current)"
    }
}

print(threads)
 
*/

// Solution 2: Serial Queue with AtomicStorage class

/*

class AtomicStorage {
    private let lockQueue = DispatchQueue(label: "my.serial.lock.queue")
    private var storage: [Int: String]
    
    init() {
        self.storage = [:]
    }
    
    func get(_ key: Int) -> String? {
        lockQueue.sync {
            storage[key]
        }
    }
    
    func set(_ key: Int, value: String) {
        lockQueue.sync {
            storage[key] = value
        }
    }
    
    var allValues: [Int: String] {
        lockQueue.sync {
            storage
        }
    }
}

let storage = AtomicStorage()
DispatchQueue.concurrentPerform(iterations: 100) { i in
    storage.set(i, value: "\(Thread.current)")
}
print(storage.allValues)

 */

// Solution 3: AtomicStorage class with Concurrent Queue and barrier flag for write

/*

class AtomicStorage {
    private let concurrentQueue = DispatchQueue(label: "my.concurrent.lock.queue", attributes: .concurrent)
    private var storage: [Int: String]
    
    init() {
        self.storage = [:]
    }
    
    func get(_ key: Int) -> String? {
        concurrentQueue.sync {
            storage[key]
        }
    }
    
    func set(_ key: Int, value: String) {
        concurrentQueue.async(flags: .barrier) { [unowned self] in
            storage[key] = value
        }
    }
    
    var allValues: [Int: String] {
        concurrentQueue.sync {
            storage
        }
    }
}

let storage = AtomicStorage()
DispatchQueue.concurrentPerform(iterations: 100) { i in
    storage.set(i, value: "\(Thread.current)")
}
dump(storage.allValues)

*/

// Solution 4: Swift 5.5, AtomicStorage class with Actor

/*

actor AtomicStorage {

    private var storage: [Int: String]
    
    init() {
        self.storage = [:]
    }
        
    func get(_ key: Int) -> String? {
        storage[key]
    }
    
    func set(_ key: Int, value: String) {
        storage[key] = value
    }

    var allValues: [Int: String] {
        storage
    }
}

Task {
    let storage = AtomicStorage()
    await withTaskGroup(of: Void.self) { group in
        for i in 0..<100 {
            group.async {
                await storage.set(i, value: "\(Thread.current)")
            }
        }
    }
    print(await storage.allValues)
}
 
 */

// Solution 5: Swift 5.5, AtomicStorage class with Actor & Thread Number

/*

extension Thread {
    var number: String {
        "\(value(forKeyPath: "private.seqNum")!)"
    }
}

actor AtomicStorage {

    private var storage: [Int: String]
    
    init() {
        print("init actor thread: \(Thread.current.number)")
        self.storage = [:]
    }
        
    func get(_ key: Int) -> String? {
        storage[key]
    }
    
    func set(_ key: Int, value: String) {
        storage[key] = value + ", actor thread: \(Thread.current.number)"
    }

    var allValues: [Int: String] {
        print("allValues actor thread: \(Thread.current.number)")
        return storage
    }
}


Task {
    let storage = AtomicStorage()
    await withTaskGroup(of: Void.self) { group in
        for i in 0..<100 {
            group.async {
                await storage.set(i, value: "caller thread: \(Thread.current.number)")
            }
        }
    }
    for (k, v) in await storage.allValues {
        print(k, v)
    }
}

 */

//: [Next](@next)
