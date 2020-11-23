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
    let comp: CGFloat = 0.15 // TODO document these variables
    var lightColor = UIColor(), normalColor = UIColor.label
    var placesAfterDecimal = 2
    
    // systemPink is the default color
    var colorQueue: Array<UIColor> = [.systemIndigo, .systemGreen, .systemOrange, .systemYellow, .systemPink]
    
    func shiftColor() -> UIColor {
        colorQueue.append(colorQueue.remove(at: 0))
        return colorQueue.last ?? UIColor.label
    }
    
    @IBOutlet var mult: UIButton!
    @IBOutlet var div: UIButton!
    @IBOutlet var plus: UIButton!
    @IBOutlet var min: UIButton!
    @IBOutlet var eq: UIButton!
    @IBOutlet var brush: UIBarButtonItem!
    @IBOutlet var clip: UIBarButtonItem!
    @IBOutlet var share: UIBarButtonItem!
    
    var customButtons = Array<UIButton>()
    var customBarButtons = Array<UIBarButtonItem>()
        
//    let operators = (mult: "×", div: "÷", add: "+", sub: "–")
    
    var operatorElems: [String] = []
    
    var bracketStack = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        lightColor = UIColor(red: comp, green: comp, blue: comp, alpha: 1)
        display(text: placeholderText, color: lightColor)
        
        customButtons = [mult, div, plus, min, eq]
        customBarButtons = [brush, clip, share]
        
    }
    
    
    // Event handlers //
    
    
    @IBAction func inputNumber(_ sender: UIButton) {
        if String(outputScreen.text!.last!) == SpecialCharacters.rBracket.rawValue {
            display(text: Operator.mult.rawValue, color: normalColor)
        }
        display(text: sender.currentTitle!, color: normalColor)
    }
    
    
    @IBAction func inputLeftBracket(_ sender: UIButton) {
        // left brackets won't be placed after a dot
        if !last(of: outputScreen.text!, isMemberOf: SpecialCharacters.dot.rawValue) {
            bracketStack += 1
            // implicit multiplication when placed after a number or right bracket
            if Number.isMember(outputScreen.text!.last!) || last(of: outputScreen.text!, isMemberOf: SpecialCharacters.rBracket.rawValue) {
                display(text: Operator.mult.rawValue, color: normalColor)
            }
            display(text: sender.currentTitle!, color: normalColor)
        }
    }
    
    
    @IBAction func inputRightBracket(_ sender: UIButton) {
        // right brackets won't be placed after an operator, a left bracket, or a dot
        if !last(of: outputScreen.text!, isMemberOf: Operator.rawValues() + [SpecialCharacters.lBracket.rawValue, SpecialCharacters.dot.rawValue]) {
            if bracketStack > 0 {
                bracketStack -= 1
                display(text: sender.currentTitle!, color: normalColor)
            }
        }
    }
    
    
    @IBAction func inputDot(_ sender: UIButton) {
        // TODO: disallow things like 23.4215.2451
        if !(last(of: outputScreen.text!, isMemberOf: Operator.rawValues() + SpecialCharacters.rawValues()) || displayIsEmpty()) {
            display(text: sender.currentTitle!, color: normalColor)
        }
    }
    
    
    @IBAction func inputOperator(_ sender: UIButton) {
        if !(last(of: outputScreen.text!, isMemberOf: Operator.rawValues() + [SpecialCharacters.lBracket.rawValue, SpecialCharacters.dot.rawValue]) || displayIsEmpty()) {
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
        if outputScreen.text! != placeholderText {
            let tokens = turnToRPN(tokenize(outputScreen.text!))
            outputScreen.text = trimZeroes(num: parseRPN(tokens))
        }
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
    
    func last(of word: String, isMemberOf elems: [String]) -> Bool {
        // this method returns true if the last character of a string matches with any of the elements given and false otherwise
        let last = word.last!
        for elem in elems {
            if last == Character(elem) {
                return true // match found
            }
        }
        return false
    }
    
    func last(of word: String, isMemberOf elems: String...) -> Bool {
        return last(of: word, isMemberOf: elems)
    }
    
    func trimZeroes(num: Double) -> String {
        var stringNum = String(num)
        let dotIndex = String(num).firstIndex(of: Character(SpecialCharacters.dot.rawValue))!
        
        if stringNum.contains(Character(SpecialCharacters.dot.rawValue)) {
            for i in stringNum.indices.reversed() {
                if stringNum[i] == "0" {
                    stringNum.remove(at: i)
                }
                else if stringNum[i] == Character(SpecialCharacters.dot.rawValue) {
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
        let dotIndex = String(num).firstIndex(of: Character(SpecialCharacters.dot.rawValue))!
        var firstNum = ""
        for digit in stringNum[dotIndex..<stringNum.endIndex] {
            if digit == Character(SpecialCharacters.dot.rawValue) {
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
    
    
    func displayIsEmpty() -> Bool {
        return outputScreen.text == placeholderText
    }
    
    // TOOLBAR CONTROL
    
    @IBAction func toggleColor(_ sender: UIBarButtonItem) {
        let color = shiftColor()
        for item in customButtons {
            item.backgroundColor = color
        }
        for item in customBarButtons {
            item.tintColor = color
        }
    }
    
    @IBAction func copyText(_ sender: UIBarButtonItem) {
        
    }
    
}

