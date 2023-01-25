//
//  ViewController.swift
//  Concurrency_DataRace
//
//  Created by Gopal Gurram on 1/25/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var statusLabel: UILabel!
    
    @IBAction func startButtonAction(_ sender: UIButton) {
//        updateCount()
//        updateCountUsingAsync()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.statusLabel.text = "0"
    }
    
    // MARK: - Problem
    
    // MARK: Data Race Use case 1: Using DispatchGroup

    func updateCount() {
        let totalCount = 1000
        let counter = Counter()
        let group = DispatchGroup()

        // Call `addCount()` asynchronously 1000 times
        for _ in 0..<totalCount {
            
            DispatchQueue.global().async(group: group) {
                counter.addCount()
            }
        }

        group.notify(queue: .main) {
            // Dispatch group completed execution
            // Show `count` value on label
            self.statusLabel.text = "\(counter.count)"
            dump(group)
        }
    }
    
    // MARK: Data Race Use case 1: Using Async Tasks
    
    func updateCountUsingAsync() {
        let totalCount = 1000
        let counter = Counter()

        // Create a parent task
        Task {
            
            // Create a task group
            await withTaskGroup(of: Void.self, body: { taskGroup in
                
                for _ in 0..<totalCount {
                    // Create child task
                    taskGroup.addTask {
                        counter.addCount()
                    }
                }
            })
            
            statusLabel.text = "\(counter.count)"
        }
    }
    
    // MARK: - Solution
    
    // MARK: Fixing Data Race using Actor's
    
    func updateCountUsingActor() {
        let totalCount = 1000
        let counter_Actor = Counter_Actor()

        // Create a parent task
        Task {
            
            // Create a task group
            await withTaskGroup(of: Void.self, body: { taskGroup in
                
                for _ in 0..<totalCount {
                    // Create child task
                    taskGroup.addTask {
                        await counter_Actor.addCount()
                    }
                }
            })
            
            statusLabel.text = "\(await counter_Actor.count)"
        }
    }
}

