//: [Previous](@previous)

/*
 
 Link:
    - https://theswiftdev.com/promises-in-swift-for-beginners/
 
 - Sync v/s Async:
    - Sync:
        - synchoronousfunction usually blocks the current thread and returns some value later on.
 
    - Async:
        - asynchronousfunction will instantly return and passes the result value into a completion handler.
 
*/


import Foundation

// MARK: - Sync V/S Async

// Use Case 1:

/*

func aBlockingFunction() -> String {
    sleep(.random(in: 1...3))
    return "Hello world!"
}

func syncMethod() -> String {
    return aBlockingFunction()
}

func asyncMethod(completion block: @escaping ((String) -> Void)) {
//    DispatchQueue.global(qos: .background).async {
//        block(aBlockingFunction())
//    }
    
    DispatchQueue.global().async {
        block(aBlockingFunction())
    }
}

print(syncMethod())
print("sync method returned")
asyncMethod { value in
    print(value)
}
print("async method returned")
 
 */

// Use Case 2: fakeAsyncMethod

/*

func syncMethod() -> String {
    return "Hello world!"
}

func fakeAsyncMethod(completion block: ((String) -> Void)) {
    block("Hello world!")
}

print(syncMethod())
print("sync method returned")
fakeAsyncMethod { value in
    print(value)
}
print("fake async method returned")

 */

// MARK: - Callback hell and the pyramid of doom

/*

struct Todo: Codable {
    let id: Int
    let title: String
    let completed: Bool
}

func request(_ url: URL, completion: @escaping ((Data) -> Void)) {
    URLSession.shared.dataTask(with: url) { data, response, error in
        if let error = error {
            fatalError("Network error: " + error.localizedDescription)
        }
        
        guard let response = response as? HTTPURLResponse else {
            fatalError("Not a HTTP response")
        }
        
        guard response.statusCode <= 200, response.statusCode > 300 else {
            fatalError("Invalid HTTP status code")
        }
        
        guard let data = data else {
            fatalError("No HTTP data")
        }
        
        completion(data)
    }.resume()
}


let url = URL(string: "https://jsonplaceholder.typicode.com/todos")!
request(url) { data in
    do {
        let todos = try JSONDecoder().decode([Todo].self, from: data)
        guard let first = todos.first else {
            return
        }
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/\(first.id)")!
        request(url) { data in
            do {
                let todo = try JSONDecoder().decode(Todo.self, from: data)
                print(todo)
            }
            catch {
                fatalError("JSON decoder error: " + error.localizedDescription)
            }
        }
    }
    catch {
        fatalError("JSON decoder error: " + error.localizedDescription)
    }
}

*/

//: [Next](@next)
