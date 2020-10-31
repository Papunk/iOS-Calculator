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
        
        // Testing parsing:
        print("\n", tokenize(expression: "((3+2×(35—2)))+(5÷1)×5—(3—(4+1))"))
      
    }
    
    
    // Event handlers //
    
    
    @IBAction func inputNumber(_ sender: UIButton) {
        if String(outputScreen.text!.last!) == SpecialCharacters.rightBracket.rawValue {
            display(text: Operator.mult.rawValue, color: normalColor)
        }
        display(text: sender.currentTitle!, color: normalColor)
    }
    
    
    @IBAction func inputLeftBracket(_ sender: UIButton) {
        if checkLast(of: outputScreen.text!, SpecialCharacters.dot.rawValue) {
            bracketStack += 1
            if Number.rawValues().contains(outputScreen.text!.last!) || String(outputScreen.text!.last!) == SpecialCharacters.rightBracket.rawValue {
                display(text: Operator.mult.rawValue, color: normalColor)
            }
            display(text: sender.currentTitle!, color: normalColor)
        }
    }
    
    
    @IBAction func inputRightBracket(_ sender: UIButton) {
        if checkLast(of: outputScreen.text!, operatorElems + [SpecialCharacters.leftBracket.rawValue, SpecialCharacters.dot.rawValue]) {
            if bracketStack > 0 {
                bracketStack -= 1
                display(text: sender.currentTitle!, color: normalColor)
            }
        }
    }
    
    
    @IBAction func inputDot(_ sender: UIButton) {
        // TODO: disallow things like 23.4215.2451
        if checkLast(of: outputScreen.text!, operatorElems + SpecialCharacters.rawValues()) && !displayIsEmpty() {
            display(text: sender.currentTitle!, color: normalColor)
        }
    }
    
    
    @IBAction func inputOperator(_ sender: UIButton) {
        if checkLast(of: outputScreen.text!, operatorElems + [SpecialCharacters.leftBracket.rawValue, SpecialCharacters.dot.rawValue]) && !displayIsEmpty() {
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
    
    func reduceTextSize() {
        //this func will make sure that text doesnt slide off the end of the screen
    }
    
    
    func checkLast(of word: String, _ elems: String...) -> Bool {
        // TODO: this function and its overloaded twin need serious documentation!
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

