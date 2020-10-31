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

func getResult(_ a: Double, _ b: Double, _ f: (Double, Double) -> Double) -> Double {
    return f(a, b)
}



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
    
    static func isMember(_ num: String) -> Bool {
        for val in self.allCases {
            if num == String(val.rawValue) {
                return true
            }
        }
        return false
    }
    
    static func isMember(_ num: Character) -> Bool {
        return isMember(num: String(num))
    }
    
    static func isValidDouble(_ str: String) -> Bool {
        for char in str {
            if !Number.isMember(num: char) && String(char) != SpecialCharacters.dot.rawValue {
                return false
            }
        }
        return true
    }
    
}

enum SpecialCharacters: String, CaseIterable {
    case leftBracket = "("
    case rightBracket = ")"
    case dot = "."
    
    static func rawValues() -> [String] {
        var values = Array<String>()
        for val in SpecialCharacters.allCases {
            values.append(val.rawValue)
        }
        return values
    }
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



func tokenize(_ exp: String) -> [String] {
    /**
     #Desc:
     This function takes a string that represents a mathematical expression tokenizes it. It assumes correct notation and has no way to verify if the statement is valid.
     */
    var tokens = [String]()
    var currentToken = ""
    var inBracket = false
    var bracketStack = 0
 
    func saveCurrentToken() {
        tokens.append(currentToken)
        currentToken = ""
    }
    
    for char in exp {
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
                saveCurrentToken()
            }
        }
        else if Number.isMember(num: elem) || Operator.isMember(num: elem) {
            currentToken += elem
            if !inBracket {
                saveCurrentToken()
            }
        }
        
//        print(String(bracketStack) + " " + String(char))
        
    }
    
    return tokens
}

func parse(_ exp: String) -> Double {
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
    
    var result: Double = 0
    
    for token in tokenize(exp) {
        
    }
    return 0
}
