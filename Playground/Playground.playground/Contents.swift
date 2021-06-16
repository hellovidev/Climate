import UIKit

// MARK: - Test

var greeting = { print("Hello, playground") }
print(greeting())
greeting()

// MARK: - Closures

func calculator(n1: Int, n2: Int, operation: (Int, Int) -> Int) -> Int {
    return operation(n1, n2)
}

func add(n1: Int, n2: Int) -> Int {
    return n1 + n2
}

// No. 1 version
let resultAdd = calculator(n1: 2, n2: 3, operation: add)

// No. 2 version
let resultMul = calculator(n1: 2, n2: 3, operation: { (no1: Int, no2: Int) -> Int in
    return no1 * no2
})

// No. 3 version
let resultSub = calculator(n1: 2, n2: 3, operation: { no1, no2 in
    return no1 - no2
})

// No. 4 version
let resultDel = calculator(n1: 2, n2: 3, operation: { (no1, no2) in no1 / no2 })

// No. 5 version - With anonymus parameter name
let resultMul2 = calculator(n1: 2, n2: 3, operation: { $0 * $1 })

// No. 6 version - If closure is last parameter name
let resultDel2 = calculator(n1: 2, n2: 3) { $0 / $1 }

print(resultAdd)
print(resultMul)
print(resultSub)
print(resultDel)
print(resultMul2)
print(resultDel2)

// Practice

let array = [6, 2, 6, 7, 0, 1, 4, 9]

print("Array >")
array.map {
    print($0)
}

print("Increase 1 to every element of array >")
print(array.map(increase))

func increase(num: Int) -> Int {
    return num + 1
}

print(array.map { $0 + 1 })

let newStringArray = array.map { "\($0)" }
print(newStringArray)

// MARK: - Extensions

// Thats why we can write extension to add functionality to struct or class
extension Double {
    func round(to places: Int) -> Double {
        let precision = pow(10, Double(places))
        var value = self
        value *= precision
        value.round()
        value /= precision
        return value
    }
}

var myDouble = 3.14159

//myDouble.round()

// But .round(to: 3) Does not exists to make 3.141

let myRoundedDouble =
//let myRoundedDouble = String(format: "%.1f", myDouble)

// And use it like this
myDouble.round(to: 2)
print(myRoundedDouble)

// Practice

let button = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
                                    
button.backgroundColor = .red

extension UIButton {
    func toCircle() {
        //self.layer.cornerRadius = 25
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }
}

button.toCircle()

// If you use extensions for protocols you should write implementation of functionality which would be default for all inherit classes (and you can use class without implementation protocol methods because it already have realization) and you can override this protocol method in class

protocol Fly {
    func fly()
}

extension Fly {
    func fly() {
        print("Object can fly!")
    }
}

class Airplane: Fly {
    // You can use or not protocol function
}

let airplane = Airplane()
airplane.fly()
