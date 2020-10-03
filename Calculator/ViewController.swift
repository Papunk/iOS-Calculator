//
//  ViewController.swift
//  Calculator
//
//  Created by Pedro Pagán on 10/3/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var outputScreen: UILabel!
    var placeholderText = "Hello"
    let comp: CGFloat = 0.15
    var lightColor = UIColor(), normalColor: UIColor = .label
    
    
//    let operators = (mult: "×", div: "÷", add: "+", sub: "—")
    
    var operatorElems: [String] = []
    
    var bracketStack = 0
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        lightColor = UIColor(red: comp, green: comp, blue: comp, alpha: 1)
        display(text: placeholderText, color: lightColor)
        
        
        
        for op in MathToken.Operator.allCases {
            operatorElems.append(op.rawValue)
        }
    }
    
    
    // Event handlers //
    
    
    @IBAction func inputNumber(_ sender: UIButton) {
        if String(outputScreen.text!.last!) == MathToken.special.rightBracket {
            display(text: MathToken.Operator.mult.rawValue, color: normalColor)
        }
        display(text: sender.currentTitle!, color: normalColor)
    }
    
    
    @IBAction func inputLeftBracket(_ sender: UIButton) {
        if checkLast(of: outputScreen.text!, MathToken.special.dot) {
            bracketStack += 1
            if MathToken.numbers.contains(String(outputScreen.text!.last!)) || String(outputScreen.text!.last!) == MathToken.special.rightBracket {
                display(text: MathToken.Operator.mult.rawValue, color: normalColor)
            }
            display(text: sender.currentTitle!, color: normalColor)
        }
    }
    
    
    @IBAction func inputRightBracket(_ sender: UIButton) {
        if checkLast(of: outputScreen.text!, operatorElems + [MathToken.special.leftBracket, MathToken.special.dot]) {
            if bracketStack > 0 {
                bracketStack -= 1
                display(text: sender.currentTitle!, color: normalColor)
            }
        }
    }
    
    
    @IBAction func inputDot(_ sender: UIButton) {
        // TODO: disallow things like 23.4215.2451
        if checkLast(of: outputScreen.text!, operatorElems + MathToken.specialElems) && !displayIsEmpty() {
            display(text: sender.currentTitle!, color: normalColor)
        }
    }
    
    
    @IBAction func inputOperator(_ sender: UIButton) {
        if checkLast(of: outputScreen.text!, operatorElems + [MathToken.special.leftBracket, MathToken.special.dot]) && !displayIsEmpty() {
            display(text: sender.currentTitle!, color: normalColor)
        }
    }
    
    
    @IBAction func inputClear(_ sender: UIButton) {
        clearScreen()
        bracketStack = 0
        display(text: placeholderText, color: lightColor)
    }
    
    
    @IBAction func swipeToErase(_ sender: UISwipeGestureRecognizer) {
        if outputScreen.text?.count ?? -1 > 0 {
            outputScreen.text?.removeLast()
        }
    }
    
    
    @IBAction func swipeToUndo(_ sender: UISwipeGestureRecognizer) {
        
    }
    
    
    @IBAction func getResult(_ sender: UIButton) {
        /**
         # Three layered approach:
         - parenthesis
         - multiplication and division from left to right
         - addition and subtraction from left to right
         */
        if outputScreen.text != placeholderText {
            outputScreen.text = String(calculate(exp: outputScreen.text!))

        }
    }
    
    func calculate(exp: String) -> Int {
        // parenthesis
        var nextExp: String
        for i in 0 ..< exp.count {
            // TODO learn about strings in swift (maybe do some classic parsing practice)
        }
        return 0
    }
    
    
    
    
    
    
    // Helper functions //
    
    
    func clearScreen() {
        outputScreen.text = ""
    }
    
    
    func display(text: String, color: UIColor) {
        outputScreen.textColor = color
        if outputScreen.text == placeholderText {
            clearScreen()
        }
        outputScreen.text! += text
    }
    
    
    func checkLast(of word: String, _ elems: String...) -> Bool {
        return checkLast(of: word, elems)
    }
    
    
    func checkLast(of word: String, _ elems: [String]) -> Bool {
        let last = word.last!
        for elem in elems {
            if last == Character(elem) {
                return false // match found
            }
        }
        return true
    }
    
    
    func displayIsEmpty() -> Bool {
        return outputScreen.text == placeholderText
    }
}

