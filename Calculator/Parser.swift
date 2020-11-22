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

func tokenize(_ exp: String) -> [String] {
    var tokens = [String]()
    var currentToken = ""
    
    func saveCurrentToken() {
        tokens.append(currentToken)
        currentToken = ""
    }
    
    for char in exp {
        let elem = String(char)
        // number
        if Number.isMember(elem) || elem == SpecialCharacters.dot.rawValue {
            currentToken += elem
        }
        // other
        else {
            if !currentToken.isEmpty {
                saveCurrentToken()
            }
            currentToken = elem
            saveCurrentToken()
        }
    }
    
    return tokens
}

func turnToRPN(_ exp: [String]) -> String {

    return ""
}

func parseRPN(_ exp: String) -> Double {
    return 0
}




let mult = { (a: Double, b: Double) -> Double in a * b}
let div = { (a: Double, b: Double) -> Double in a / b}
let add = { (a: Double, b: Double) -> Double in a + b}
let sub = { (a: Double, b: Double) -> Double in a - b}

func getResult(_ a: Double, _ b: Double, _ f: (Double, Double) -> Double) -> Double {
    return f(a, b)
}
