//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Chun on 2019/9/30.
//  Copyright © 2019 NJU. All rights reserved.
//

import UIKit

class Calculator: NSObject {
    
    enum Operation {
        case UnaryOp((Fraction) ->Fraction)
        case BinaryOp((Fraction, Fraction) -> Fraction)
        case EqualsOp
        case Constant(Fraction)
    }
    
    var operations  = [
        
        "+": Operation.BinaryOp({(op1, op2) in
            return op1+op2
        }),
        
        "−": Operation.BinaryOp({(op1: Fraction, op2: Fraction) -> Fraction in
            return op1-op2
        }),
        
        "×": Operation.BinaryOp({ $0 * $1 }),
        
        "÷": Operation.BinaryOp({ $0 / $1 }),
        
        "=": Operation.EqualsOp,
        
        "C": Operation.UnaryOp({_ in return Fraction()}),
        
        "±": Operation.UnaryOp({ Fraction() - $0}),
        
        "%": Operation.UnaryOp({ Fraction(fromString: "0.01") * $0 }),
    ]
    
    
    func performOperation(operation: String, operand: Fraction)  -> Fraction? {
        if let op = operations[operation]{
            switch op {
            case .BinaryOp(let function):
                pendingOp = Intermediate(firstOp: operand, waitingOperation: function)
                return nil
            case .UnaryOp(let function):
                return function(operand)
            case .EqualsOp:
                if let theOperation =  pendingOp {
                    return theOperation.waitingOperation(theOperation.firstOp, operand)
                }
            case .Constant(let value):
                return value
            }
        }
        return nil
    }
    
    var pendingOp: Intermediate? = nil
    
    
    struct Intermediate {
        var firstOp: Fraction
        var waitingOperation : (Fraction, Fraction) -> Fraction
    }

}
