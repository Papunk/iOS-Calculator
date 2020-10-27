//
//  Parser.swift
//  Calculator
//
//  Created by Pedro Pagán on 10/22/20.
//

import Foundation

let mult = { (a: Double, b: Double) -> Double in a * b}
let div = { (a: Double, b: Double) -> Double in a / b}
let add = { (a: Double, b: Double) -> Double in a + b}
let sub = { (a: Double, b: Double) -> Double in a - b}

let numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]



enum Number: Int, CaseIterable {
    case zero = 0
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    
    static func rawValues() -> [Character] {
        var values = Array<Character>()
        for val in Number.allCases {
            values.append(Character(UnicodeScalar(val.rawValue)!)) // this cast could be problematic
        }
        return values
    }
    
    static func isMember(num: String) -> Bool {
        for val in self.allCases {
            if num == String(val.rawValue) {
                return true
            }
        }
        return false
    }
}

enum SpecialCharacters: String, CaseIterable {
    case leftBracket = "("
    case rightBracket = ")"
    case dot = "."
}

enum Operator: String, CaseIterable {
    case mult = "×"
    case div = "÷"
    case add = "+"
    case sub = "—"
    
    static func isMember(num: String) -> Bool {
        for val in self.allCases {
            if num == String(val.rawValue) {
                return true
            }
        }
        return false
    }
}

func getResult(_ a: Double, _ b: Double, _ f: (Double, Double) -> Double) -> Double {
    return f(a, b)
}

func tokenize(expression: String) -> [String] {
    /**
     #Desc:
     This function takes a string that represents a mathematical expression tokenizes it
     */
    var tokens = Array<String>()
    var currentToken = ""
    var inBracket = false
    var bracketStack = 0
    
    // work here
//    var i = 0
//    while i < expression.count {
//        let char = expression[expression.index(expression.startIndex, offsetBy: i)]
//
//        if char == SpecialCharacters.leftBracket.rawValue {
//            currentToken += String(char)
//            inBracket = true
//            while true {
//                i += 1
//                currentToken += String(char)
//            }
//        }
//        i += 1
//    }
    
    func nextToken() {
        tokens.append(currentToken)
        currentToken = ""
    }
    
    // deprecated:
    for char in expression {
        let elem = String(char)
        
        if elem == SpecialCharacters.leftBracket.rawValue {
            currentToken += elem
            if bracketStack == 0 { // opening new scope
                inBracket = true
            }
            bracketStack += 1
        }
        else if elem == SpecialCharacters.rightBracket.rawValue {
            currentToken += elem
            bracketStack -= 1
            if bracketStack == 0 { // closing the scope
                inBracket = false
                nextToken()
            }
        }
        else if Number.isMember(num: elem) {
            currentToken += elem
            if !inBracket {
                nextToken()
            }
        }
        else if Operator.isMember(num: elem) {
            currentToken += elem
            if !inBracket {
                nextToken()
            }
        }
//        print(String(bracketStack) + " " + String(char))
        
    }
    
    return tokens
}

func parse(expression: String) -> Double {
    /**
     #Desc
     parser a math expression and returns the result
     */
    // tokenize expression
    // whenever a parenthesis is found, recursion is used to solve
    // otherwise:
    // first pass to look for multiplications and divisions
    // second pass to look for additions and subtractions
    // base case: only two numbers
    return 0
}
