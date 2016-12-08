//
//  ViewController.swift
//  Calculator
//
//  Created by Алексей Неронов on 07.12.16.
//  Copyright © 2016 Алексей Неронов. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var display: UILabel!
    
    var userIsInTheMiddleOfTyping = false
    
    @IBAction func touchDigit(_ sender: UIButton) {
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
    
    @IBAction func performOperation(_ sender: UIButton) {
        if let mathematicalSymbol = sender.currentTitle {
            if mathematicalSymbol == "pi" {
                display.text = "\(M_PI)"
            }
            userIsInTheMiddleOfTyping = false
        }
    }
    
}

