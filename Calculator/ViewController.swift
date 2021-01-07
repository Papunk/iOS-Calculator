//
//  ViewController.swift
//  Calculator
//
//  Created by Pedro Pagán on 10/3/20.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var topDisplay: UILabel!
    @IBOutlet var outputScreen: UILabel!
    @IBOutlet var eraseSwipe: UISwipeGestureRecognizer!
    var placeholderText = "Hello"
    // Colors used around the UI
    var lightColor = UIColor.lightGray, normalColor = UIColor.label
    
    
    let placesAfterDecimal = 2
    var gotResult = false
    
    var previousResults = [String]()
    
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
    @IBOutlet var stack: UIBarButtonItem!
    @IBOutlet var extra: UIBarButtonItem!
    @IBOutlet var gear: UIBarButtonItem!
    
    var customButtons = Array<UIButton>()
    var customBarButtons = Array<UIBarButtonItem>()
            
    var operatorElems: [String] = []
    
    var bracketStack = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        display(text: placeholderText, color: lightColor)
        
        customButtons = [mult, div, plus, min, eq]
        customBarButtons = [brush, stack, extra, gear]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    
    // Event handlers //
    
    
    @IBAction func inputNumber(_ sender: UIButton) {
        if String(outputScreen.text!.last!) == AuxElem.rBracket.rawValue {
            display(text: Operator.mult.rawValue, color: normalColor)
        }
        display(text: sender.currentTitle!, color: normalColor)
    }
    
    
    @IBAction func inputLeftBracket(_ sender: UIButton) {
        // left brackets won't be placed after a dot
        guard !last(of: outputScreen.text!, isMemberOf: AuxElem.dot.rawValue) else { return }
        
        bracketStack += 1
        // implicit multiplication when placed after a number or right bracket
        if getKind(of: outputScreen.text!.last!) == Math.num || last(of: outputScreen.text!, isMemberOf: AuxElem.rBracket.rawValue) {
            display(text: Operator.mult.rawValue, color: normalColor)
        }
        display(text: sender.currentTitle!, color: normalColor)
    }
    
    
    @IBAction func inputRightBracket(_ sender: UIButton) {
        // right brackets won't be placed after an operator, a left bracket, or a dot
        guard getKind(of: outputScreen.text!.last!) != Math.op && !last(of: outputScreen.text!, isMemberOf: [AuxElem.lBracket.rawValue, AuxElem.dot.rawValue]) else { return }
        guard bracketStack > 0 else { return }
        
        bracketStack -= 1
        display(text: sender.currentTitle!, color: normalColor)
    }
    
    
    @IBAction func inputDot(_ sender: UIButton) {
        // TODO: disallow things like 23.4215.2451
        if (getKind(of: outputScreen.text!.last!) != Math.op && getKind(of: outputScreen.text!.last!) != Math.aux) || displayIsEmpty() {
            display(text: sender.currentTitle!, color: normalColor)
        }
    }
    
    
    @IBAction func inputOperator(_ sender: UIButton) {
        guard getKind(of: outputScreen.text!.last!) != Math.op && !(last(of: outputScreen.text!, isMemberOf: [AuxElem.lBracket.rawValue, AuxElem.dot.rawValue]) || displayIsEmpty()) else { return }

        display(text: sender.currentTitle!, color: normalColor)
    }
    
    
    @IBAction func inputClear(_ sender: UIButton) {
        clearScreen()
        bracketStack = 0
        display(text: placeholderText, color: lightColor)
    }
    
    
    @IBAction func swipeToErase(_ sender: UISwipeGestureRecognizer) {
        guard eraseSwipe.direction == .left else { return }
        print("hello") // testing
        outputScreen.text!.removeLast()
    }
    
    
    @IBAction func getResult(_ sender: UIButton) {
        guard outputScreen.text! != placeholderText else { return }
        
        // generate and display the result
        outputScreen.text = trimZeroes(num: parseRPN(turnToRPN(tokenize(outputScreen.text!))))
        // flag
        gotResult = true
        // add results to history
        previousResults.append(outputScreen.text!)
        print(previousResults)
    }

    
    
    // Helper functions //
    
    
    func clearScreen() {
        outputScreen.text = ""
    }
    
    
    func display(text: String, color: UIColor) {
        outputScreen.textColor = color
        if outputScreen.text == placeholderText || (gotResult && getKind(of: text) != Math.op) {
            clearScreen()
        }
        gotResult = false
        outputScreen.text! += text
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
    
    @IBAction func showResultHistory(_ sender: UIBarButtonItem) {
        print(previousResults)
        if !previousResults.isEmpty && previousResults.last! == outputScreen.text! {
            previousResults.removeLast()
        }
        clearScreen()
        if !previousResults.isEmpty {
            display(text: previousResults.popLast()!, color: normalColor)
        }
        else {
            display(text: placeholderText, color: lightColor)
        }
    }
}

