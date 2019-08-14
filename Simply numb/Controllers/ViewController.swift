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
    
    var currentInput: Double {
        get {
            return Double(displayResultLabel.text!)!
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
    
    @IBAction func numberPressed(_ sender: UIButton) {
        
        let number = sender.currentTitle!
        
        if stillTyping {
            guard displayResultLabel.text!.count < 12 else { return }
            displayResultLabel.text = displayResultLabel.text! + number
        } else {
            displayResultLabel.text = number
            stillTyping = true
        }
        
        AudioServicesPlaySystemSound(0x450)
    }
    @IBAction func twoOperendsPressed(_ sender: UIButton) {
        operationSign = sender.currentTitle!
        firstOperand = currentInput
        stillTyping = false
        pointIsPlace = false
        
        AudioServicesPlaySystemSound(0x450)
    }
    
    @IBAction func equalityPressed(_ sender: UIButton) {
        
        if stillTyping  {
            secondOperand = currentInput
        }
        
        pointIsPlace = false
        
        switch operationSign {
        case "+": operateWithTwoOperands{$0 + $1}
        case "-": operateWithTwoOperands{$0 - $1}
        case "×": operateWithTwoOperands{$0 * $1}
        case "÷":
            if secondOperand == 0.0 {
                guard displayResultLabel.text == nil else { return showResulsLabel.text = "Error! You can devide on 0"}
              // displayResultLabel.text = "Error! You can devide on 0"
            } else {
                operateWithTwoOperands{$0 / $1}
            }
        default: break
        }
        AudioServicesPlaySystemSound(0x450)
    }
    
    @IBAction func AcButtonTapped(_ sender: UIButton) {
        firstOperand = 0
        secondOperand = 0
        currentInput = 0
        displayResultLabel.text = "0"
        showResulsLabel.text = displayResultLabel.text
        stillTyping = false
        operationSign = ""
        pointIsPlace = false
        AudioServicesPlaySystemSound(0x450)
    }
    
    @IBAction func plusMinusButton(_ sender: UIButton) {
        currentInput = -currentInput
        AudioServicesPlaySystemSound(0x450)
    }
    @IBAction func ansButtonPresed(_ sender: UIButton) {
    }
    @IBAction func procentButton(_ sender: UIButton) {
        if firstOperand == 0 {
            currentInput = currentInput / 100
        } else {
            secondOperand = firstOperand * currentInput / 100
        }
    }
    
    @IBAction func pointButtonPresed(_ sender: UIButton) {
        if stillTyping && !pointIsPlace {
            displayResultLabel.text = displayResultLabel.text! + "."
            pointIsPlace = true
        } else if !stillTyping && !pointIsPlace {
            displayResultLabel.text = "0."
        }
    }
    
    
    func operateWithTwoOperands(operation:(Double, Double) -> Double) {
        currentInput = operation(firstOperand, secondOperand)
        stillTyping = false
    }
    
}



