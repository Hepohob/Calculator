//
//  ViewController.swift
//  Calculator
//
//  Created by Алексей Неронов on 07.12.16.
//  Copyright © 2016 Алексей Неронов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private var display: UILabel!
    
    private var userIsInTheMiddleOfTyping = false
    private var brain = CalculatorBrain()
    
    @IBAction private func touchDigit(_ sender: UIButton) {
        if let digit = sender.currentTitle {
            if let textCurrentlyInDisplay = display.text {
                if userIsInTheMiddleOfTyping {
                    display.text = textCurrentlyInDisplay + digit
                }
                else {
                    display.text = digit
                }
                userIsInTheMiddleOfTyping = true
            }
        }
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    @IBAction private func performOperation(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            userIsInTheMiddleOfTyping = false
            brain.set(operand: displayValue)
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(symbol: mathematicalSymbol)
        }
        displayValue = brain.result
    }
    
}

