//: [Previous](@previous)

/*
 
 Link:
    - https://cocoacasts.com/choosing-between-nsoperation-and-grand-central-dispatch
 
 - NSOperation:
    - Objective-C API
    - Instances of NSOperation need to be allocated before they can be used and deallocated when they are no longer needed.
    - Even though this is a highly optimized process, it is inherently slower than Grand Central Dispatch, which operates at a lower level.
    - Benefit's of NSOperation:
        - Dependencies: An operation is ready when every dependency has finished executing.
        - Observable: Using KVO we can monitor the state of an operation or operation queue.
        - Pause, Cancel, Resume:
        - Control: You can specify the maximum number of queued operations that can run simultaneously.
    - When to Use NSOperation:
        - Encapsulate the login sequence of an application.
        - If you need to perform several tasks in a specific order, then operations are a good solution.
        -
 
*/

import Foundation



//: [Next](@next)
