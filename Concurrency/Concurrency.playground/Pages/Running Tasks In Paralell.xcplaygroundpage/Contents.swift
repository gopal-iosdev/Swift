//: [Previous](@previous)

/*
 
 Link:
    - https://theswiftdev.com/running-tasks-in-parallel/
 
 - Running tasks in parallel:
    - Learn how to run tasks in parallel using the old-school tools and frameworks plus the new structured concurrency API in Swift.
 
*/

import Foundation
import Dispatch

// MARK: - 1.) Using concurrentPerform in Dispatch Framework.
// Problem of using concurrentPerform: each worker has to work on quite a lot of numbers, maybe we shouldn't start all the workers at once, but use a pool and run only a subset of them at a time.
/*
let workers: Int = 8
let numbers: [Int] = Array(repeating: 1, count: 1_000_000_000)

var sum = 0
DispatchQueue.concurrentPerform(iterations: workers) { index in
    let start = index * numbers.count / workers
    let end = (index + 1) * numbers.count / workers
    print("Worker #\(index), items: \(numbers[start..<end].count)")

    sum += numbers[start..<end].reduce(0, +)
}

print("Sum: \(sum)")
 */

// MARK: - 2.) Using Operation Queues to use a pool and run only a subset of them at a time
// Problem with Mark-1 & 2 approaches is they depend on additional frameworks. In other words they are non-native Swift solutions. What if we could do something better using structured concurrency?

/*
let workers: Int = 8
let numbers: [Int] = Array(repeating: 1, count: 1_000_000_000)

let operationQueue = OperationQueue()
operationQueue.maxConcurrentOperationCount = 4

var sum = 0
for index in 0..<workers {
    let operation = BlockOperation {
        let start = index * numbers.count / workers
        let end = (index + 1) * numbers.count / workers
        print("Worker #\(index), items: \(numbers[start..<end].count)")
        
        sum += numbers[start..<end].reduce(0, +)
    }
    operationQueue.addOperation(operation)
}

operationQueue.waitUntilAllOperationsAreFinished()

print("Sum: \(sum)")
 */

// MARK: - 3.) Using structured concurrency
// Problem with Mark - 3 is, Is it possible to limit the maximum number of concurrent operations, just like we did with operation queues? 🤷‍♂️

/*
let workers: Int = 8
let numbers: [Int] = Array(repeating: 1, count: 1_000_000_000)

let sum = await withTaskGroup(of: Int.self) { group in
    for i in 0..<workers {
        group.addTask {
            let start = i * numbers.count / workers
            let end = (i + 1) * numbers.count / workers
            return numbers[start..<end].reduce(0, +)
        }
    }

    var summary = 0
    for await result in group {
        summary += result
    }
    return summary
}

print("Sum: \(sum)")
 */

// MARK: - 4.)

func parallelTasks<T>(
    iterations: Int,
    concurrency: Int,
    block: @escaping ((Int) async throws -> T)
) async throws -> [T] {
    try await withThrowingTaskGroup(of: T.self) { group in
        var result: [T] = []

        for i in 0..<iterations {
            if i >= concurrency {
                if let res = try await group.next() {
                    result.append(res)
                }
            }
            group.addTask {
                try await block(i)
            }
        }

        for try await res in group {
            result.append(res)
        }
        return result
    }
}


let workers: Int = 8
let numbers: [Int] = Array(repeating: 1, count: 1_000_000_000)

let res = try await parallelTasks(
    iterations: workers,
    concurrency: 4
) { i in
    print(i)
    let start = i * numbers.count / workers
    let end = (i + 1) * numbers.count / workers
    return numbers[start..<end].reduce(0, +)
}

print("Sum: \(res.reduce(0, +))")


//: [Next](@next)
