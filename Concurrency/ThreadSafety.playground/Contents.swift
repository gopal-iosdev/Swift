/*
 Source:
 - https://medium.com/cubo-ai/concurrency-thread-safety-in-swift-5281535f7d3a
 
 
 */


import UIKit

// MARK: - Concurrency & Thread Safety in Swift

// MARK: Race Conditions

// Problem

/*

struct IPhone {
    static var stock = 2000
}

//let serialQueue = DispatchQueue(label: "SerialQueue")
//let concurrentQueue = DispatchQueue(label: "ConcurrentQueue", attributes: .concurrent)
//let lock = NSLock()
//let semaphore = DispatchSemaphore(value: 0)

class AppleStore {
    let location: String
    
    init(location: String) {
        self.location = location
    }
    
    func sell(value: Int) {
        print("\(location): start transaction process...")
        
        if IPhone.stock > value {
            // sleeping for some time, simulating server process
            Thread.sleep(forTimeInterval: Double.random(in: 0...1))
            IPhone.stock -= value
            print("\(self.location): \(value) has been sold")
            print("current balance is \(IPhone.stock)")
            if IPhone.stock < 0 {
                print("there is a stock issue")
            }
            
        } else {
            print("\(self.location): Can't sell due to insufficent balance")
        }
    }
}

func tryRaceCondition() {
    let appleStoreUS = AppleStore(location: "US")
    let appleStoreTW = AppleStore(location: "TW")
    let queue = DispatchQueue(label: "sellQueue", attributes: .concurrent)
    
    queue.async {
        appleStoreUS.sell(value: 1000)
    }
    
    dump("Finished First Block")
    
    queue.async {
        appleStoreTW.sell(value: 1500)
    }
    
    dump("Finished Second Block")
}

tryRaceCondition()

 */

// Solution

/*

struct IPhone {
   static var stock = 2000
}

class AppleStore {
   let location: String
   
   init(location: String) {
       self.location = location
   }
   
   func sell(value: Int) {
       print("\(location): start transaction process...")
       if IPhone.stock > value {
           // sleeping for some time, simulating server process
           Thread.sleep(forTimeInterval: Double.random(in: 0...1))
           IPhone.stock -= value
           print("\(location): \(value) has been sold")
           print("current balance is \(IPhone.stock)")
           if IPhone.stock < 0 {
               print("there is a stock issue")
           }
       } else {
           print("\(location): Can't sell due to insufficent balance")
       }
   }
}

// Approach 1: DispatchBarrier

func avoidRaceConditionWithDispatchBarrier() {
    let appleStoreUS = AppleStore(location: "US")
    let appleStoreTW = AppleStore(location: "TW")
    let queue = DispatchQueue(label: "sellQueue", attributes: .concurrent)
    
    queue.async(flags: .barrier) {
        appleStoreUS.sell(value: 1000)
    }
    
    dump("Finished First Block")
    
    queue.async(flags: .barrier) {
        appleStoreTW.sell(value: 1500)
    }
    
    dump("Finished Second Block")
}

//avoidRaceConditionWithDispatchBarrier()

// Approach 2: Semaphore

func avoidRaceConditionWithSemaphore() {
    let appleStoreUS = AppleStore(location: "US")
    let appleStoreTW = AppleStore(location: "TW")
    
    let globalQueue = DispatchQueue.global()
    let queue = DispatchQueue(label: "sellQueue", attributes: .concurrent)
    let semaphore = DispatchSemaphore(value: 0)
    
    globalQueue.async {
        queue.async{
            appleStoreUS.sell(value: 1000)
            semaphore.signal()
        }
        
        dump("Finished First Block")
        
        semaphore.wait()

        queue.async{
            appleStoreTW.sell(value: 1500)
            semaphore.signal()
        }
        
        dump("Finished Second Block")
        
        semaphore.wait()
    }
    
}

//avoidRaceConditionWithSemaphore()

// Approach 3: NSLock

func avoidRaceConditionWithLock() {
    let appleStoreUS = AppleStore(location: "US")
    let appleStoreTW = AppleStore(location: "TW")
    
    let queue = DispatchQueue(label: "sellQueue", attributes: .concurrent)
    let lock = NSLock()
    
    queue.async{
        lock.lock()
        appleStoreUS.sell(value: 1000)
        lock.unlock()
    }
    
    dump("Finished First Block")
    
    queue.async{
        lock.lock()
        appleStoreTW.sell(value: 1500)
        lock.unlock()
    }
    
    dump("Finished Second Block")
}

avoidRaceConditionWithLock()

*/



// MARK: Deadlocks

// Problem

/*

import UIKit

var arrA = [Int]()
var arrB = [Int]()
let lockA = NSLock()
let lockB = NSLock()
let myQueueA = DispatchQueue(label: "my.queue.a")
let myQueueB = DispatchQueue(label: "my.queue.b")

for i in 0..<100 {
    myQueueA.async {
        lockA.lock()
        lockB.lock()
        arrA.append(i)
        arrB.append(i * 2)
        lockB.unlock()
        lockA.unlock()
    }
}

for _ in 0..<100 {
    myQueueB.async {
        lockB.lock()
        lockA.lock()
        if !arrA.isEmpty {
            arrA.removeLast()
        }
        if !arrB.isEmpty {
            arrB.removeLast()
        }
        lockA.unlock()
        lockB.unlock()
    }
}

print(arrA, arrB)

*/

// Solution


