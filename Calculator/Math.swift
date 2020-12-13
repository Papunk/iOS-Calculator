//
//  Math.swift
//  Calculator
//
//  Created by Pedro Pagán on 12/12/20.
//

enum Number: Int, CaseIterable {
    /**
     This enum contains a named instance of every number
     */
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


enum AuxElem: String, CaseIterable {
    /**
     This enum contains a auxiliry characters needed in math parsing
     */
    case lBracket = "("
    case rBracket = ")"
    case dot = "."
}

enum Operator: String, CaseIterable {
    /**
     This enum contains the symbols used for the fundamental arithmetic operations
     */
    case mult = "×"
    case div = "÷"
    case add = "+"
    case sub = "–"
}


enum Math {
    case num
    case aux
    case op
    case invalid
}

func getKind(of item: String) -> Math {
    // check if Number
    for value in Number.allCases {
        if String(value.rawValue) == item {
            return Math.num
        }
    }
    // check if AuxElem
    for value in AuxElem.allCases {
        if value.rawValue == item {
            return Math.aux
        }
    }
    // check if Operator
    for value in Operator.allCases {
        if value.rawValue == item {
            return Math.op
        }
    }
    // invalid
    return Math.invalid
}

func getKind(of item: Character) -> Math {
    return getKind(of: String(item))
}
