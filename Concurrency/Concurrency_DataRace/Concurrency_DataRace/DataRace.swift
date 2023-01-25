//
//  DataRace.swift
//  Concurrency_DataRace
//
//  Created by Gopal Gurram on 1/25/23.
//

import Foundation

// A data race occurs when 2 or more threads trying to access (read/write) the same memory location asynchronously at the same time.

class Counter {
    var count = 0
    
    func addCount() {
        count += 1
    }
}

actor Counter_Actor {
    
    private(set) var count = 0
    
    func addCount() {
        count += 1
    }
}

