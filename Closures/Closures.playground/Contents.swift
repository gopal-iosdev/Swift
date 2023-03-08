import UIKit

/**
 - Closures:
 
 - Source: https://www.youtube.com/watch?v=bi_2iKGv2Cg
 
 Note:
 - You can avoid doing weak self for non escaping closures:
     - ^^^ means you can safely use self inside non escaping closures.
 - Closures with @escaping are aloowed to keep in memory even that the functions we passed them to are returned.
 */

// MARK: - Not capturing values

// Closures do not captures values by default.

/*

var someInteger = 2

let closure = {
    print(someInteger)
}

someInteger = 3

closure()
*/

// MARK: - Capturing values

// Closures captures values using capture list.

/*

var someInteger = 2

let closure = { [someInteger] in
    print(someInteger)
}

someInteger = 3

closure()

*/

// MARK: - Creating Memor leaks

// Problem

/*
class ViewController: UIViewController {
    var timer: Timer?
    var label = UILabel()
    let formatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // timer below causes retain cycle.
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let now = Date()
            
            self.label.text = self.formatter.string(from: now)
        }
    }
}
 */

// Solution

/*
 class ViewController: UIViewController {
 var timer: Timer?
 var label = UILabel()
 let formatter = DateFormatter()
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
 guard let self else { return }
 
 let now = Date()
 
 self.label.text = self.formatter.string(from: now)
 }
 }
 }
 */


