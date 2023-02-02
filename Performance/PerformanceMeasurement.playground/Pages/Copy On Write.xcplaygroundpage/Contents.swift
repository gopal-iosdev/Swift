//: [Previous](@previous)

/*
 
 Link:
    - https://arturgruchala.com/copy-on-write-in-swift-explained-with-examples/
 
 
 - Swift Copy on Write:
    - Swift has two basic data types - reference type (class, closure) and value type (struct, enum, touple).
    - Reference type points to the same place in memory. Every time you assign a reference type to a new value it implicitly points to the shared object.
    - Value type is copied to the new place every time you assign, initialize, and pass it as an argument.
        - This is true for almost all of the swift structs. But some of them are special. For example Arrays and other Collections. They implement copy on write mechanism. This means the array will be copied only when we mutate its content (not always - I'll show you an exception!).
 
 
*/

import Foundation

// MARK: - Copy on write example

/*
 We will create a new command line tool for testing our assumptions. We will need something to print memory addresses, dummy structures and classes, and testing code.
 */

// MARK: Helpers

// Prints address of structure
func address(o: UnsafeRawPointer)  {
    
    print(NSString(format: "%p", Int(bitPattern: o)))
}

// Prints address of class
func addressHeap<T: AnyObject>(o: T) {
    
    print(NSString(format: "%p", unsafeBitCast(o, to: Int.self)))
}

// MARK: Dummy types

struct Foo {
    var foo = 1
}

class Bar {
    var bar = 1
}

// MARK: Making struct to be CoW

final class Ref<T> {
  var val: T
  init(_ v: T) { val = v }
}

struct Box<T> {
  var ref: Ref<T>
  init(_ x: T) { ref = Ref(x) }

  var value: T {
    get { return ref.val }
    set {
      if !isKnownUniquelyReferenced(&ref) {
        ref = Ref(newValue)
        return
      }
      ref.val = newValue
    }
  }
}

@propertyWrapper
struct CopiedOnWrite<T: Any> {
    public let wrapped: Box<T>
    
    public var wrappedValue: T {
        return wrapped.value
    }
    
    public init(wrappedValue: T) {
        wrapped = Box(wrappedValue)
    }
}

// MARK: Testing

var foo1 = Foo()
var foo2 = foo1
address(o: &foo1) // 0x104fa8960
address(o: &foo2) // 0x104fa8968

var bar1 = Bar()
var bar2 = bar1
addressHeap(o: bar1) //0x600000339400
addressHeap(o: bar2) //0x600000339400

// Copy On Write for Structs

print("###### Testing Copy On Write For Structs ######")

var fooArray1 = (1...3).map { _ in Foo() }
var fooArray2 = fooArray1
address(o: &fooArray1) // 0x60000331fb60
address(o: &fooArray2) // 0x60000331fb60

fooArray1[0].foo = 2

address(o: &fooArray1) // 0x60000331e0e0
address(o: &fooArray2) // 0x60000331fb60

// Copy On Write for Classes

print("###### Testing Copy On Write For Classes ######")

var barArray1 = (1...3).map { _ in Bar() }
var barArray2 = barArray1
address(o: &barArray1) // 0×6000017085a0
address(o: &barArray2) // 0x6000017085a0
barArray1[0].bar = 2
address(o: &barArray1) // 0x6000017085a0
address(o: &barArray2) // 0x6000017085a0

// MARK:

print("###### Testing Copy On Write For Structs ######")

var fooArray11 = (1...3).map { _ in Box(Foo()) }
var fooArray21 = fooArray11
address(o: &fooArray11) //
address(o: &fooArray21) //

fooArray1[0].foo = 21

address(o: &fooArray11)
address(o: &fooArray21)


//: [Next](@next)
