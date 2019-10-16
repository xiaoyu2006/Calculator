//
//  ViewController.swift
//  Calculator
//
//  Created by Chun on 2019/9/30.
//  Copyright © 2019 NJU. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var display: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    var calculator = Calculator()
    
    var fraction = Fraction()
    
    var inTypingMiddle = false
    var doted = false
    
    var digitOnDisplay: String{
        get{
            return self.display.text!
        }
        set{
            self.display.text = newValue
        }
    }
    
    
    @IBAction func digitalButtonTouched(_ sender: UIButton) {
        if let currentDigit = sender.currentTitle {
            if inTypingMiddle{
                if currentDigit == "." {
                    if doted {
                        return
                    }
                    doted = true
                }
                digitOnDisplay = digitOnDisplay + currentDigit
            } else{
                digitOnDisplay = currentDigit
                inTypingMiddle = true
                doted = false
            }
        }
    }
    @IBAction func fracBtnPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Fraction:", message: fraction.toFrac(), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func operButtonTouched(_ sender: UIButton){
        if let op = sender.currentTitle {
            if inTypingMiddle {
                fraction = Fraction(fromString: digitOnDisplay)
            }
            // print(digitOnDisplay)
            if let result = calculator.performOperation(operation: op, operand: fraction) {
                digitOnDisplay = result.toString()
                fraction = result
            }
            inTypingMiddle = false
        }
    }

}

