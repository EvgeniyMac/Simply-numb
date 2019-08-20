//
//  ViewController.swift
//  Simply numb
//
//  Created by Evgeniy Suprun on 8/11/19.
//  Copyright © 2019 Evgeniy Suprun. All rights reserved.
//

import UIKit
import AudioToolbox

class ViewController: UIViewController {
    
    
    @IBOutlet weak var displayResultLabel: UILabel!
    
    @IBOutlet weak var showResulsLabel: UILabel!
    
    var stillTyping = false
    var pointIsPlace = false
    var firstOperand: Double = 0
    var secondOperand: Double = 0
    var operationSign: String = ""
    var ansOperand = false
    var ansOperandNumber = 0.0
    var number: String = ""
    var alert = false
    var minus = false
    

    var currentInput: Double {
        get {
            if Double(displayResultLabel.text!) == nil {
                return 0
            } else {
               return Double(displayResultLabel.text!)!
            }
        }
        
        set {
            let value = "\(newValue)"
            let valueArray = value.components(separatedBy: ".")
            if valueArray[1] == "0" {
                displayResultLabel.text = "\(valueArray[0])"
            } else {
                displayResultLabel.text = "\(newValue)"
            }
            stillTyping = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.gradientBackgroundColor()
    }
    
    // Change status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Numbers button
    
    @IBAction func numberPressed(_ sender: UIButton) {
        
        number = sender.currentTitle!
    
        if stillTyping && currentInput != 0 {
            guard displayResultLabel.text!.count < 12 else { return }
            displayResultLabel.text = displayResultLabel.text! + number
            showResulsLabel.text = showResulsLabel.text! + number
        } else if showResulsLabel.text!.count < 2 {
            displayResultLabel.text = number
            showResulsLabel.text = number
            stillTyping = true
        } else if currentInput == 0 && !operationSign.isEmpty && !pointIsPlace {
            displayResultLabel.text! = number
            showResulsLabel.text?.removeLast()
             showResulsLabel.text! += number
            stillTyping = true
        } else if pointIsPlace {
            displayResultLabel.text! += number
            showResulsLabel.text! += number
        } else {
            displayResultLabel.text = number
            showResulsLabel.text! += number
            stillTyping = true
        }
    
        if showResulsLabel.text!.count > 27 {
            showResulsLabel.text = "..."
        }
        
        errorDivideZero(sender: sender)
    }
    
    // Two operand presed
    @IBAction func twoOperendsPressed(_ sender: UIButton) {
        operationSign = sender.currentTitle!
        firstOperand = currentInput
        stillTyping = false
        pointIsPlace = false
        errorDivideZero(sender: sender)
    }
    
    // Button equily (=)
    @IBAction func equalityPressed(_ sender: UIButton) {
        
        if stillTyping {
            secondOperand = currentInput
        }

        pointIsPlace = false
        
        
        switch operationSign {
        case "+": operateWithTwoOperands{$0 + $1}
        case "-": operateWithTwoOperands{$0 - $1}
        case "×": operateWithTwoOperands{$0 * $1}
        case "÷":
            if secondOperand == 0.0 {
                 showResulsLabel.text = "Error! You can divide by zero"
                    stillTyping = false
                } else {
                operateWithTwoOperands{$0 / $1}
            }
        default: break
        }
  
        showResultinSecondLabel(sender: sender)

    }
    
    // Button clear all
    
    @IBAction func AcButtonTapped(_ sender: UIButton) {
        firstOperand = 0
        secondOperand = 0
        currentInput = 0
        displayResultLabel.text = "0"
        showResulsLabel.text = displayResultLabel.text
        stillTyping = false
        operationSign = ""
        pointIsPlace = false
        ansOperand = false
        alert = false
        AudioServicesPlaySystemSound(0x450)
    }
    
    // Button set + - to constant
    @IBAction func plusMinusButton(_ sender: UIButton) {
        
        currentInput = -currentInput
        if firstOperand == 0.0 {
            showResulsLabel.text! = displayResultLabel.text!
        } else {
            secondOperand = currentInput

             let numberCount = displayResultLabel.text!.count
            
            if (secondOperand < 0)
            {
              let ourString = showResulsLabel.text!.removeCharsFromEnd(count: numberCount - 1)
                showResulsLabel.text = ourString + "(\(displayResultLabel.text!))"
            }
            else
            {
                let ourString = showResulsLabel.text!.removeCharsFromEnd(count: numberCount + 3)
                showResulsLabel.text = ourString + "\(displayResultLabel.text!)"
            }
            
        }
        stillTyping = false
        errorDivideZero(sender: sender)
    }
    
    // Button save constant in memory
    @IBAction func ansButtonPresed(_ sender: UIButton) {
        
        if ansOperand {
            displayResultLabel.text = String(ansOperandNumber)
            currentInput = ansOperandNumber
            secondOperand = currentInput
        } else {
            ansOperandNumber = currentInput
            ansOperand = true
        }
       
        
        errorDivideZero(sender: sender)
    }
    
    // Button procent for number
    @IBAction func procentButton(_ sender: UIButton) {
        
        if firstOperand == 0 {
            currentInput = currentInput / 100
        } else {
            currentInput = currentInput / 100
             secondOperand = currentInput
        }
        stillTyping = false
        
        errorDivideZero(sender: sender)
    }
    
    // Button check and set point
    
    @IBAction func pointButtonPresed(_ sender: UIButton) {
        
        if stillTyping && !pointIsPlace {
            displayResultLabel.text = displayResultLabel.text! + "."
            showResulsLabel.text! = showResulsLabel.text! + "."
            pointIsPlace = true
    
        } else if !stillTyping && !pointIsPlace {
            displayResultLabel.text! += "."
            showResulsLabel.text! += "."
            pointIsPlace = true
            
        }
    
        errorDivideZero(sender: sender)
    }
    
    // Button remove last text in 1 and second label
    
    @IBAction func removeLastButton(_ sender: UIButton) {
    
        var number: String = "\(currentInput)"
        number = String(showResulsLabel.text!.dropLast())
        
        if showResulsLabel.text!.count < 2 {
            currentInput = 0.0
        } else {
            if let cost = Double(number) {
                currentInput = cost
            } else {
               currentInput = -0
            }
        }
        
        if showResulsLabel.text!.count < 2  {
            showResulsLabel.text = "0"
        } else {
           showResulsLabel.text = String(showResulsLabel.text!.dropLast())
        }
        errorDivideZero(sender: sender)
    }
    
    // Method works with two operands
    
    func operateWithTwoOperands(operation:(Double, Double) -> Double) {
        currentInput = operation(firstOperand, secondOperand)
        currentInput = currentInput.roundToDecimal(10)
        stillTyping = false
    }
    
    // Method Show result in second label and Check for divide for 0
    func showResultinSecondLabel(sender: UIButton) {
        if showResulsLabel.text != "Error! You can divide by zero" {
            showResulsLabel.text = showResulsLabel.text! + sender.currentTitle!
            let results = showResulsLabel.text!.last
            if results == "=" {
                showResulsLabel.text! += displayResultLabel.text!
            }
        } else {
            showResulsLabel.text = "Error! You can divide by zero"
            alert = true
        }
        
    }
    
    // Method reset all button after you divide by zero + play push button sound
    
    func errorDivideZero(sender: UIButton) {
        if alert {
            firstOperand = 0
            secondOperand = 0
            currentInput = 0
            displayResultLabel.text = "0"
            showResulsLabel.text = displayResultLabel.text
            stillTyping = false
            operationSign = ""
            pointIsPlace = false
            ansOperand = false
            alert = false
        } else {
            AudioServicesPlaySystemSound(0x450)
        }
    }
}

