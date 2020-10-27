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
    
    static func isNumber() -> Bool {
        return true
    }
}

enum SpecialCharacters: Character, CaseIterable {
    case leftBracket = "("
    case rightBracket = ")"
    case dot = "."
}

enum Operator: Character, CaseIterable {
    case mult = "×"
    case div = "÷"
    case add = "+"
    case sub = "—"
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
    
    // deprecated:
    for char in expression {
        if char == SpecialCharacters.leftBracket.rawValue {
            currentToken += String(char)
            if bracketStack == 0 { // opening new scope
                inBracket = true
            }
            bracketStack += 1
        }
        else if char == SpecialCharacters.rightBracket.rawValue {
            currentToken += String(char)
            bracketStack -= 1
            if bracketStack == 0 { // closing the scope
                inBracket = false
                tokens.append(currentToken)
                currentToken = ""
            }
        }
        else if Number.rawValues().contains(char) {
            currentToken += String(char)
        }
        print(String(bracketStack) + " " + String(char))
        
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
