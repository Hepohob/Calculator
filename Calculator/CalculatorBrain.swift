//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Алексей Неронов on 08.12.16.
//  Copyright © 2016 Алексей Неронов. All rights reserved.
//

import Foundation



func multiply(op1:Double, op2:Double) -> Double {
    return op1 * op2
}

class CalculatorBrain
{
    private var accumulator = 0.0
    private var internalProgram = [AnyObject]()
    
    typealias PropertyList = AnyObject
    
    var program : PropertyList {
        get {
            return internalProgram as PropertyList
        }
        set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        set(operand: operand)
                    }
                    if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        internalProgram.removeAll()
    }
    
    private func rand() {
        accumulator = Double(arc4random_uniform(2))
    }
    
    func set(operand:Double)
    {
        accumulator = operand
        internalProgram.append(operand as AnyObject)
    }
    
    private var operations: Dictionary<String,Operation> = [
        "π" : Operation.Constant(M_PI), // M_PI,
        "e" : Operation.Constant(M_E), //M_E
        "√" : Operation.UnaryOperation(sqrt),
        "rand" : Operation.Rand,
        "M" : Operation.UnaryOperation(sqrt),
        "MRC" : Operation.UnaryOperation(sqrt),
        "◀︎" : Operation.Delete,
        "C" : Operation.Clear,
        "±" : Operation.UnaryOperation({ -$0 }),
        "ln" : Operation.UnaryOperation(log),
        "x⁻¹" : Operation.UnaryOperation({ pow($0 , -1) }),
        "cos" : Operation.UnaryOperation(cos),
        "sin" : Operation.UnaryOperation(sin),
        "tan" : Operation.UnaryOperation(tan),
        "cos⁻¹" : Operation.UnaryOperation(acos),
        "sin⁻¹" : Operation.UnaryOperation(asin),
        "tan⁻¹" : Operation.UnaryOperation(atan),
        "x²" : Operation.UnaryOperation({ pow($0 , 2) }),
        "✕" : Operation.BinaryOperation({ $0 * $1 }),
        "÷" : Operation.BinaryOperation({ $0 / $1 }),
        "+" : Operation.BinaryOperation({ $0 + $1 }),
        "-" : Operation.BinaryOperation({ $0 - $1 }),
        "=" : Operation.Equals
    ]
    
    private enum Operation {
        case Constant(Double)
        case UnaryOperation((Double) -> Double)
        case BinaryOperation((Double, Double) -> Double)
        case Equals
        case Clear
        case Rand
        case Delete
    }
    
    func performOperation(symbol: String) {
        if let operation = operations[symbol] {
            internalProgram.append(symbol as AnyObject)
            switch operation {
            case .Constant(let value):
                accumulator = value
            case .UnaryOperation(let function):
                accumulator = function(accumulator)
            case .BinaryOperation(let function):
                executePendingBinaryOperation()
                pending = PendingBinaryOperationInfo(binaryFunction: function, firstOperand: accumulator)
            case .Equals:
                executePendingBinaryOperation()
            case .Clear:
                clear()
            case .Rand:
                rand()
            case .Delete:
                delete()
            }
        }
    }
    
    private func delete() {
        var str = String(accumulator)
        if (str.hasSuffix(".0")) && (str.characters.count > 2) {
            str = str.substring(to: str.index(str.endIndex, offsetBy: -3))
        } else {
            let index = str.index(str.endIndex, offsetBy: -1)
            str = str.substring(to: index)
            if str.characters.last == "." {
                str = str.substring(to: str.index(str.endIndex, offsetBy: -1))
            }
        }
        accumulator = Double(str) ?? 0.0
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private func  executePendingBinaryOperation() {
        if pending != nil {
            accumulator = pending!.binaryFunction(pending!.firstOperand,accumulator)
            pending = nil
        }
    }
    
    private struct PendingBinaryOperationInfo {
        var binaryFunction: (Double, Double) -> Double
        var firstOperand: Double
    }
    
    var result: Double {
        get {
            return accumulator
        }
    }
}
