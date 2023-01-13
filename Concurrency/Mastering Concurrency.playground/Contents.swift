/*
 - Source:
    - https://www.youtube.com/watch?v=X9H2M7xMi9E&ab_channel=iCode

 - Concurrency:
 -
 
 */

import PlaygroundSupport
import Foundation

PlaygroundPage.current.needsIndefiniteExecution = true

// MARK: - Manually creating a thread

/*

class CustomThread {
    var thread: Thread?
    
    func createThread() {
        thread = Thread(target: self, selector: #selector(threadSelector),  object: nil)
                                    
        thread?.start()
    }
    
    func cancelThread() {
        thread?.cancel()
    }
    
    @objc func threadSelector() {
        dump("Custom thread in action")
    }
}

let customThread = CustomThread()
customThread.createThread()
print(customThread.thread?.isExecuting, customThread.thread?.isFinished, customThread.thread?.isCancelled)
customThread.cancelThread()
print(customThread.thread?.isExecuting, customThread.thread?.isFinished, customThread.thread?.isCancelled)

*/

// MARK: - DispatchQueue

/*

var counter = 1

// Main Queue

/*

DispatchQueue.main.async {
    for i in 0...3 {
        counter = i
        print("\(counter)")
    }
}

for i in 4...6 {
    counter = i
    print("\(counter)")
}

DispatchQueue.main.async {
    counter = 9
    print("\(counter)")
}

DispatchQueue.main.async {
    print(Thread.isMainThread ? "Main Thread" : "Other Thread")
}

 */

// MARK: Global Queue

// default Queue

/*
 
DispatchQueue.global(qos: .default).async {
    for i in 0...3 {
        counter = i
        print("\(counter)")
    }
}

DispatchQueue.global(qos: .default).sync {
    for i in 6...9 {
        counter = i
        print("\(counter)")
    }
}

DispatchQueue.global(qos: .default).async {
    counter = 9
    print("\(counter)")
}

DispatchQueue.global(qos: .default).async {
    print(Thread.isMainThread ? "Main Thread" : "Other Thread")
}

*/

// backgound, User interactive, .. etc

/*
 
DispatchQueue.global(qos: .background).async {
    for i in 11...21 {
        print(i)
    }
}

DispatchQueue.global(qos: .userInteractive).async {
    for i in 0...10 {
        print(i)
    }
}

 */

*/

// MARK: - Custom Queue

/*

let a = DispatchQueue(label: "A")

let b = DispatchQueue(label: "B", attributes: .concurrent, target: a)

a.async {
    for i in 0...5 {
        print(i)
    }
}

a.async {
    for i in 6...10 {
        print(i)
    }
}

b.async {
    for i in 11...15 {
        print(i)
    }
}

a.async {
    for i in 16...20 {
        print(i)
    }
}

*/

// MARK: - Custom Serial Queue

/*
 var value = 20
 let serialQueue = DispatchQueue(label: "com.queue.Serial")
 
 func doAsyncTaskInSerialQueue() {
 for i in 1...3 {
 serialQueue.sync {
 if Thread.isMainThread {
 print("Task is running on main thread")
 } else {
 print("Task is running on other thread")
 }
 
 let imageURL = URL(string: "https://images.dog.ceo/breeds/newfoundland/n02111277_357.jpg")
 
 let _ = try! Data(contentsOf: imageURL!)
 print("\(i) finished downloading image")
 }
 }
 }
 
 doAsyncTaskInSerialQueue()
 
 serialQueue.async {
 for i in 0...3 {
 value = i
 print("\(value) ⭐️")
 }
 }
 
 print("Last line in playground")
 
 */

// MARK: - Custom Concurrent Queue

/*

var value = 20
let concurrentQueue = DispatchQueue(label: "com.queue.Serial", attributes: .concurrent)
 
func doAsyncTaskInConcurentQueue() {
    for i in 1...3 {
        concurrentQueue.sync {
            if Thread.isMainThread {
                print("Task is running on main thread")
            } else {
                print("Task is running on other thread")
            }
            
            let imageURL = URL(string: "https://images.dog.ceo/breeds/newfoundland/n02111277_357.jpg")
            
            let _ = try! Data(contentsOf: imageURL!)
            print("\(i) finished downloading image")
        }
    }
}
 
doAsyncTaskInConcurentQueue()
 
concurrentQueue.async {
    for i in 0...3 {
        value = i
        print("\(value) ⭐️")
    }
}
 
 print("Last line in playground")
 
 */
