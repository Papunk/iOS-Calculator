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
}

func getResult(_ a: Double, _ b: Double, _ f: (Double, Double) -> Double) -> Double {
    return f(a, b)
}

func parseMath(_ expression: String) {
    for char in expression {
        
    }
}
