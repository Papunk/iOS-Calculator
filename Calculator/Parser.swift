//
//  Parser.swift
//  Calculator
//
//  Created by Pedro Pagán on 10/22/20.
//

import Foundation


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
        return isMember(String(num))
    }
    
    static func isValidDouble(_ str: String) -> Bool {
        for char in str {
            if !Number.isMember(char) && String(char) != SpecialCharacters.dot.rawValue {
                return false
            }
        }
        return true
    }
    
}

enum SpecialCharacters: String, CaseIterable {
    case lBracket = "("
    case rBracket = ")"
    case dot = "."
    
    
    
    // TODO: TURN rawValues() INTO AN INDEPENDENT FUNCTION
    
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
    
    static func isMember(_ op: String) -> Bool {
        for val in self.allCases {
            if op == String(val.rawValue) {
                return true
            }
        }
        return false
    }
    
    static func rawValues() -> [String] {
        var values = Array<String>()
        for val in Operator.allCases {
            values.append(val.rawValue)
        }
        return values
    }
}



func tokenize(_ expression: String) -> [String] {
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
    
    
    // TODO: check for a case like: (3-2*(2+1)-1)
    
    for char in expression {
        let elem = String(char)
        
        if elem == SpecialCharacters.lBracket.rawValue {
            currentToken += elem
            if bracketStack == 0 { // opening new scope
                inBracket = true
            }
            bracketStack += 1
        }
        else if elem == SpecialCharacters.rBracket.rawValue {
            currentToken += elem
            bracketStack -= 1
            if bracketStack == 0 { // closing the scope
                inBracket = false
                saveCurrentToken()
            }
        }
        else if Number.isMember(elem) || Operator.isMember(elem) {
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
    
    func calculate(a: Double, b: Double, op: Operator) -> Double {
        switch op {
        case .mult:
            return a * b
        case .div:
            return a / b
        case .add:
            return a + b
        case .sub:
            return a - b
        }
    }
    
    
    var tokens = tokenize(exp)
    var tokenPlaceholder = Array<String>()
    var result: Double = 0
    
    if tokens.count == 1 {
        return Double(tokens[0])!
    }
    
    // first pass
    for i in 0...tokens.count-1 {
        print(i)
        // multiplication
        if tokens[i] == Operator.mult.rawValue {
            let a = parse(tokens[i-1])
            let b = parse(tokens[i+1])
            tokenPlaceholder.append(String(calculate(a: a, b: b, op: Operator.mult)))
        }
        // division
        else if tokens[i] == Operator.div.rawValue {
            let a = parse(tokens[i-1])
            let b = parse(tokens[i+1])
            tokenPlaceholder.append(String(calculate(a: a, b: b, op: Operator.div)))
        }
    }
    
    // second pass
    for i in 0...tokens.count-1 {
        if tokens[i] == Operator.add.rawValue || tokens[i] == Operator.sub.rawValue {
            // apply operation
        }
    }
    
    return result
}

let mult = { (a: Double, b: Double) -> Double in a * b}
let div = { (a: Double, b: Double) -> Double in a / b}
let add = { (a: Double, b: Double) -> Double in a + b}
let sub = { (a: Double, b: Double) -> Double in a - b}

func getResult(_ a: Double, _ b: Double, _ f: (Double, Double) -> Double) -> Double {
    return f(a, b)
}
