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


// Utility functions

func trimZeroes(num: Double) -> String {
    var stringNum = String(num)
    let dotIndex = String(num).firstIndex(of: Character(AuxElem.dot.rawValue))!
    
    if stringNum.contains(Character(AuxElem.dot.rawValue)) {
        for i in stringNum.indices.reversed() {
            if stringNum[i] == "0" {
                stringNum.remove(at: i)
            }
            else if stringNum[i] == Character(AuxElem.dot.rawValue) {
                return String(stringNum[stringNum.startIndex..<dotIndex])
            }
            else {
                break
            }
        }
    }
    return stringNum
}

func trimPeriodic(num: Double) -> String {
    let stringNum = String(num)
    let dotIndex = String(num).firstIndex(of: Character(AuxElem.dot.rawValue))!
    var firstNum = ""
    for digit in stringNum[dotIndex..<stringNum.endIndex] {
        if digit == Character(AuxElem.dot.rawValue) {
            continue
        }
        if firstNum.isEmpty {
            firstNum = String(digit)
        }
        else if String(digit) != firstNum {
            return stringNum
        }
    }
    return (String(stringNum[stringNum.startIndex...stringNum.index(after: dotIndex)]))
}
