//
//  Parser.swift
//  Calculator
//
//  Created by Pedro Pagán on 10/22/20.
//

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


enum AuxElem: String, CaseIterable {
    case lBracket = "("
    case rBracket = ")"
    case dot = "."
}

enum Operator: String, CaseIterable {
    case mult = "×"
    case div = "÷"
    case add = "+"
    case sub = "–"
}


// REFACTORED CODE

func isNumber(_ item: Double) -> Bool {
    return isNumber(String(item))
}

func isNumber(_ item: String) -> Bool {
    for num in Number.allCases {
        if String(num.rawValue) == item {
            return true
        }
    }
    return false
}






// Operators:
let mult = (sign: "×", precedence: 2, operation: {(a: Double, b: Double) -> Double in return a * b})
let div = (sign: "÷", precedence: 2, operation: {(a: Double, b: Double) -> Double in return a / b})
let add = (sign: "+", precedence: 1, operation: {(a: Double, b: Double) -> Double in return a + b})
let sub = (sign: "–", precedence: 1, operation: {(a: Double, b: Double) -> Double in return a - b})
let par = (sign: "(", precedence: 0, operation: /*Placeholder closure*/ {(a: Double, b: Double) -> Double in return 0})

let operatorList = [mult, div, add, sub, par]

func getPrecedence(_ op: String) -> Int {
    for type in operatorList {
        if type.sign == op {
            return type.precedence
        }
    }
    return -1
}

func calculate(a: Double, b: Double, op: String) -> Double {
    for type in operatorList {
        if type.sign == op {
            return type.operation(a, b)
        }
    }
    return 0
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
        if Number.isMember(elem) || elem == AuxElem.dot.rawValue {
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
    
    // Edge case: last element is a number
    if !currentToken.isEmpty && Number.isMember(currentToken.first!) {
        saveCurrentToken()
    }
    
    return tokens
}

func turnToRPN(_ exp: [String]) -> [String] {
    // Implementation of Shunting-Yard algorithm to turn algebraic expression into reverse Polish notation
    var rpnQueue = [String]()
    var operatorStack = [String]()
    
    for token in exp {
        // Number
        if Number.isMember(token.first!) {
            rpnQueue.append(token)
        }
        // Opening Bracket
        else if token == AuxElem.lBracket.rawValue {
            operatorStack.append(token)
        }
        // Closing bracket
        else if token == AuxElem.rBracket.rawValue {
            while operatorStack.last != AuxElem.lBracket.rawValue {
                rpnQueue.append(operatorStack.removeLast())
            }
            operatorStack.removeLast()
        }
        // Operator
        else if Operator.isMember(token) {
            if operatorStack.isEmpty {
                operatorStack.append(token)
            } else {
                let tokenPrecedence = getPrecedence(token)
                while !operatorStack.isEmpty && tokenPrecedence <= getPrecedence(operatorStack.last!) {
                    rpnQueue.append(operatorStack.removeLast())
                }
                operatorStack.append(token)
            }
        }
    }
    
    while (!operatorStack.isEmpty) {
        rpnQueue.append(operatorStack.removeLast())
    }
    
    return rpnQueue
}

func parseRPN(_ exp: [String]) -> Double {
    var answerStack = [Double]()
    
    for token in exp {
        if Number.isMember(token.first!) {
            answerStack.append(Double(token)!)
        }
        else if Operator.isMember(token) {
            let b = answerStack.popLast()
            let a = answerStack.popLast()
            answerStack.append(calculate(a: a!, b: b!, op: token))
        }
//        print(answerStack)
    }
    
    return answerStack.first!
}

