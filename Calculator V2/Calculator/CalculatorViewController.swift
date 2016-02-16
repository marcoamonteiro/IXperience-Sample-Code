//
//  ViewController.swift
//  Calculator
//
// Marco Monteiro

import UIKit

class CalculatorViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var displayHistory: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    var currentValue = ""
    var hasSpecialCharacter = false
    let pi = M_PI
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            display.text = display.text! + digit
        } else {
            userIsInTheMiddleOfTypingANumber=true
            display.text = digit
        }
    }
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation  = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
                if(operation == "∏") {
                    display.text = "∏"
                }
            } else {
                displayValue = nil
            }
            displayHistory.text=brain.description
        }
    }
    
    //Stores a variable in m
    @IBAction func memoryButtons(sender: UIButton) {
        if(sender.currentTitle! == "→M") {
            if let display = displayValue {
                brain.setVariableM(displayValue!)
                userIsInTheMiddleOfTypingANumber=false
                displayHistory.text = "M = "+"\(displayValue!)"
                displayValue = brain.evaluate()
            }
        } else {
            enter()
            brain.pushOperand("M")
            
        }
    }
    
    @IBAction func clear() {
        displayValue=nil
        displayHistory.text=" "
        brain.clear()
    }
    
    
    //This function evaluates the current stack, and updates the display
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if(isValidInput(display.text!)) {
            if let display = displayValue {
                if let result = brain.pushOperand(display) {
                    displayValue = result
                } else {
                    displayValue = nil
                }
            }
        } else {
            displayValue=nil
        }
        displayHistory.text=brain.description
    }
    
    var displayValue: Double? {
        get {
            if let contents  = NSNumberFormatter().numberFromString(display.text!) {
                return contents.doubleValue
            } else {
                return nil
            }
        }
        set {
            if newValue==nil {
                display.text=" "
            } else {
                display.text="\(newValue!)"
            }
            userIsInTheMiddleOfTypingANumber=false
        }
    }
    
    //Checks that decimal numbers are valid inputs
    func isValidInput(input: String) -> Bool {
        if let wholeNumberRange = input.rangeOfString(".") {
            let decimalPart = input[wholeNumberRange.startIndex..<input.endIndex]
            if let decimalRange = decimalPart.rangeOfString(".") {
                return false
            }
        }
        return true
    }
   
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destination = segue.destinationViewController as? UIViewController
        if let navCon = destination as? UINavigationController {
            destination = navCon.visibleViewController
            navCon.navigationBarHidden=false
        }
        if let gvc = destination as? GraphViewController {
            gvc.program = brain.program
        }
    }
    
}

