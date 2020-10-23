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

func tokenize(expression: String) {
    /**
     #Desc:
        This function
     */
    var tokens = Array<String>()
    var currentToken: String
    
    for char in expression {
        for op in Operator.allCases {
            if char == op.rawValue {
                
            }
        }
    }
}

func parse(expression: [String]) {
    // first pass to look for multiplications and divisions
    // second pass to look for additions and subtractions
    // whenever a parenthesis is found, recursion is used to solve
}
