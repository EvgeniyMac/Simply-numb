//
//  ViewController.swift
//  Simply numb
//
//  Created by Evgeniy Suprun on 8/11/19.
//  Copyright © 2019 Evgeniy Suprun. All rights reserved.
//

import UIKit
import AudioToolbox

enum LastCharEntered {
    case sign
    case number
    case equality
    case none
    case procent
    case ans
}

final class Calculator: UIViewController {
    
    @IBOutlet weak var displayResultLabel: UILabel!
    @IBOutlet weak var showResulsLabel: UILabel!
    
    
    private var showArrayAction: [String] = []
    private var canceledArrayAction: [String] = []
    
    private var firstOperand: Double = 0
    private var secondOperand: Double = 0
    private var ansOperandNumber: Double = 0
    
    private var lastResult: String = ""
    private var operationSign: String = ""
    
    
    private var stillTyping = false
    private var procentMinusOrAns = false
    private var pointIsPlace = false
    private var backspaceNeed = false
    private var isRemove = false
    private var alert = false
    private var divideByZero = false
    
    private var lastCharEntered: LastCharEntered = .none
    
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
            if valueArray.count > 1, valueArray[1] == "0" {
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
        if backspaceNeed != false {
            return
        }
        if showArrayAction.last == "=" {
            return
        }
        
        let number = sender.currentTitle!
        
        canceledArrayAction = []
        if showArrayAction.count == 1, showArrayAction.first == "0" {
            showArrayAction.removeLast()
            lastCharEntered = .none
        }
        if stillTyping, lastCharEntered == .number, showArrayAction.count > 0 {
            var lastNum = showArrayAction.last!
            lastNum += number
            showArrayAction.removeLast()
            showArrayAction.append(lastNum)
            
        } else if lastCharEntered != .number {
            showArrayAction.append(number)
            stillTyping = true
        }
        lastCharEntered = .number
        showResults()
        procentMinusOrAns = false
        errorDivideZero(sender: sender)
    }
    
    // Two operand presed
    @IBAction func twoOperendsPressed(_ sender: UIButton) {
        
        if backspaceNeed != false {
            return
        }
        if lastCharEntered == .none {
            return
        }
        if showArrayAction.last == "=" {
            return
        }
        
        if lastCharEntered == .sign {
            showArrayAction.removeLast()
        } else {
            firstOperand = currentInput
        }
        
        operationSign = sender.currentTitle!
        showArrayAction.append(operationSign)
        
        stillTyping = false
        pointIsPlace = false
        procentMinusOrAns = true
        
        lastCharEntered = .sign
        showResults()
        
        if showArrayAction.count > 3 {
            displayResultLabel.text = lastResult
        }
        errorDivideZero(sender: sender)
    }
    
    // Button equily (=)
    @IBAction func equalityPressed(_ sender: UIButton) {
        if backspaceNeed != false {
            return
        }
        if sender.currentTitle! == "=" && lastCharEntered == .sign {
            return
        }
        if sender.currentTitle! == "=" && lastCharEntered == .equality {
            return
        }
        if showArrayAction.last == "=" {
            return
        }
        if lastCharEntered == .none, showArrayAction.count == 1 {
            return
        }
        
        if stillTyping {
            secondOperand = currentInput
        }
        
        canceledArrayAction = []
        if isRemove == true {
            if sender.currentTitle! == "=" {
                lastCharEntered = .equality
                showArrayAction.append("=")
            }
            recalculation()
            showResults()
            return
        }
        
        operationsManage()
        
        if sender.currentTitle! == "=" {
            lastCharEntered = .equality
            showArrayAction.append("=")
            showArrayAction.append(displayResultLabel.text!)
            showResults()
        }
        pointIsPlace = false
    }
    
    // Button clear all
    
    @IBAction func AcButtonTapped(_ sender: UIButton) {
        
        clearALl()
        AudioServicesPlaySystemSound(0x450)
    }
    
    // Button set + - to constant
    @IBAction func plusMinusButton(_ sender: UIButton) {
        if backspaceNeed != false {
            return
        }
        
        
        if lastCharEntered == .equality || showArrayAction.last == "=" {
            return
        }
        
        if showArrayAction.count == 1 {
            
            currentInput = -currentInput
            
            showArrayAction.removeLast()
            showArrayAction.append(displayResultLabel.text!)
            
        } else if currentInput != 0, lastCharEntered != .sign {
            
            currentInput = -currentInput
            secondOperand = currentInput
            
            showArrayAction.removeLast()
            showArrayAction.append("(\(displayResultLabel.text!))")
            
        }
        showResults()
        errorDivideZero(sender: sender)
    }
    
    // Button save constant in memory
    @IBAction func ansButtonPresed(_ sender: UIButton) {
        if backspaceNeed != false {
            return
        }
        if showArrayAction.last == "=" {
            return
        }
        
        let ansTitle = sender.currentTitle!
        
        if !procentMinusOrAns && stillTyping {
            
            firstOperand = currentInput
            ansOperandNumber = currentInput
            secondOperand = currentInput
            
        } else if procentMinusOrAns, ansOperandNumber != 0 {
            
            currentInput = ansOperandNumber
            
            if showArrayAction.count < 3, firstOperand == 0 {
                firstOperand = ansOperandNumber
            }
            secondOperand = currentInput
            showArrayAction.append(ansTitle)
        }
        lastCharEntered = .ans
        stillTyping = false
        procentMinusOrAns = false
        showResults()
        errorDivideZero(sender: sender)
    }
    
    // Button procent for number
    @IBAction func procentButton(_ sender: UIButton) {
        if backspaceNeed != false {
            return
        }
        if lastCharEntered == .equality || showArrayAction.last == "=" {
            return
        }
        
        let procentSender = sender.currentTitle!
        
        print(currentInput)
        if currentInput == 0 {
            secondOperand = currentInput
        } else {
            currentInput = currentInput / 100
            secondOperand = currentInput
            showArrayAction.append(procentSender)
        }
        
        stillTyping = false
        procentMinusOrAns = false
        lastCharEntered = .procent
        showResults()
        errorDivideZero(sender: sender)
    }
    
    // Button check and set point
    
    @IBAction func pointButtonPresed(_ sender: UIButton) {
        if backspaceNeed != false {
            return
        }
        if showArrayAction.last == "=" {
            return
        }
        
        if stillTyping && !pointIsPlace, displayResultLabel.text != nil {
            displayResultLabel.text = displayResultLabel.text! + "."
            var lastNum = showArrayAction.last!
            lastNum += "."
            showArrayAction.removeLast()
            showArrayAction.append(lastNum)
            pointIsPlace = true
            lastCharEntered = .number
            stillTyping = true
        } else if !stillTyping && !pointIsPlace && lastCharEntered != .equality {
            displayResultLabel.text! += "0."
            showArrayAction.append("0.")
            pointIsPlace = true
            lastCharEntered = .number
            stillTyping = true
        }
        procentMinusOrAns = false
        showResults()
        errorDivideZero(sender: sender)
    }
    
    // Remove last characters
    
    @IBAction func removeLastButton(_ sender: UIButton) {
        
        guard showArrayAction.count > 0 else {
            return
        }
        
        var last = showArrayAction.last!
        
        if last == "Ans" {
            showArrayAction.removeLast()
            showResults()
            return
        }
        
        switch lastCharEntered {
        case .number:
            if last.count == 1 {
                lastCharEntered = .sign
            } else {
                stillTyping = true
            }
            
        case .sign, .procent:
            lastCharEntered = .number
            
        case .equality:
            if last == "=" {
                backspaceNeed = false
                stillTyping = true
                lastCharEntered = .number
            } else {
                backspaceNeed = true
            }
            
        case .none, .ans:
            break
        }
        
        showArrayAction.removeLast()
        if last.count > 1 {
            last.removeLast()
            showArrayAction.append(last)
        }
        if showArrayAction.count == 0 {
            showArrayAction.append("0")
            lastCharEntered = .number
        }
        showResults()
        isRemove = true
        errorDivideZero(sender: sender)
    }
    
    // Remove last Action
    
    private func cancelArrRemoveShowArrAppend() {
        canceledArrayAction.append(showArrayAction.last!)
        showArrayAction.removeLast()
    }
    
    @IBAction func cancelActionButton(_ sender: UIButton) {
        guard showArrayAction.count > 0 else { return }
        
        switch lastCharEntered {
        case .number:
            if showArrayAction.last! == "%" {
                cancelArrRemoveShowArrAppend()
            }
            if showArrayAction.count > 1 {
                cancelArrRemoveShowArrAppend()
            }
            cancelArrRemoveShowArrAppend()
        case .sign:
            lastCharEntered = .number
            cancelArrRemoveShowArrAppend()
            break
        case .procent:
            if showArrayAction.count > 2 {
                cancelArrRemoveShowArrAppend()
                cancelArrRemoveShowArrAppend()
            } else if showArrayAction.count > 1 {
                cancelArrRemoveShowArrAppend()
            }
            lastCharEntered = .number
            cancelArrRemoveShowArrAppend()
        case .ans:
            break
        case .equality:
            if showArrayAction.last! != "=" {
                cancelArrRemoveShowArrAppend()
            }
            if showArrayAction.last != nil {
                cancelArrRemoveShowArrAppend()
            }
            lastCharEntered = .number
        case .none:
            break
        }
        
        if showArrayAction.count == 0 {
            showArrayAction.append("0")
            lastCharEntered = .number
        }
        showResults()
        stillTyping = true
        isRemove = true
        backspaceNeed = false
        errorDivideZero(sender: sender)
    }
    
    
    
    // Return last Action
    
    private func showArrRemoveCancelAppend() {
        showArrayAction.append(canceledArrayAction.last!)
        canceledArrayAction.removeLast()
    }
    
    @IBAction func returnCancelActionButton(_ sender: UIButton) {
        
        if canceledArrayAction.count == 0 {
            return
        }
        
        if showArrayAction.count == 1, showArrayAction[0] == "0" {
            showArrayAction.removeLast()
            showArrRemoveCancelAppend()
            showResults()
            lastCharEntered = .none
            return
        }
        
        if canceledArrayAction.count > 1 {
            showArrRemoveCancelAppend()
        }
        
        showArrRemoveCancelAppend()
        
        if canceledArrayAction.last == "%" {
            showArrRemoveCancelAppend()
        }
        
        if showArrayAction.last == "-" || showArrayAction.last == "+" || showArrayAction.last == "×" || showArrayAction.last == "÷" {
            lastCharEntered = .sign
        } else if showArrayAction.last == "=" {
            lastCharEntered = .equality
        } else {
            lastCharEntered = .number
        }
        showResults()
        stillTyping = true
        backspaceNeed = false
        errorDivideZero(sender: sender)
    }
    
    // Method works with two operands
    
    func operateWithTwoOperands(operation:(Double, Double) -> Double) {
        currentInput = operation(firstOperand, secondOperand)
        currentInput = currentInput.roundToDecimal(10)
        lastResult = displayResultLabel.text!
        stillTyping = false
    }
    
    private func recalculation() {
        var next = 0
        var i = 0
        var isResult = false
        var isProcent = false
        while i < showArrayAction.count {
            let str = showArrayAction[i]
            if i + 1 < showArrayAction.count, showArrayAction[i + 1] == "%" {
                isProcent = true
            }
            
            if next == 0, let num = Double(str) {
                currentInput = num
                if isProcent {
                    currentInput = currentInput / 100
                }
                isResult = false
            } else {
                sort: switch str {
                case "+", "÷", "×", "-":
                    operationSign = str
                    firstOperand = currentInput
                case "%":
                    break sort
                case "Ans":
                    secondOperand = ansOperandNumber
                    operationsManage()
                case "=":
                    next = -1
                    isResult = true
                default:
                    if let num = Double(str) {
                        secondOperand = num
                        if isProcent, secondOperand != 0 {
                            secondOperand = secondOperand / 100
                        }
                    } else if str.contains("("){
                        parseNegativeNumber(str)
                    }
                    operationsManage()
                }
            }
            next += 1
            i += 1
        }
        if isResult == true {
            showArrayAction.append(displayResultLabel.text!)
        }
    }
    
    private func operationsManage() {
        
        switch operationSign {
        case "+":
            operateWithTwoOperands{$0 + $1}
        case "-":
            operateWithTwoOperands{$0 - $1}
        case "×":
            operateWithTwoOperands{$0 * $1}
        case "÷":
            if secondOperand == 0 {
                divideByZero = true
            } else {
                operateWithTwoOperands{$0 / $1}
            }
        default: break
        }
    }
    
    private func parseNegativeNumber(_ str: String) {
        var parseStr = str
        parseStr.removeFirst()
        parseStr.removeFirst()
        parseStr.removeLast()
        secondOperand = Double(parseStr)!
        secondOperand = -secondOperand
    }
    
    
    
    private func showResults() {
        var showString = showArrayAction.joined()
        
        if divideByZero {
            alert = true
            displayResultLabel.text = "0"
            showResulsLabel.text = "Error! You can't divide by zero"
            return
        }
        
        let arrayCount: Int = showArrayAction.count
        if showString.count > 27 {
            switch lastCharEntered {
            case .number:
                if arrayCount > 2 {
                    let arr = showArrayAction[arrayCount - 2...arrayCount - 1]
                    showArrayAction = [lastResult, arr[arrayCount - 2], arr[arrayCount - 1]]
                    showString = showArrayAction.joined()
                }
            case .sign:
                showString = displayResultLabel.text! + showArrayAction.last!
                showArrayAction = [displayResultLabel.text!, showArrayAction.last!]
            case .equality:
                showString = showArrayAction.last!
                showArrayAction = [showString]
            case .none:
                break
            case .ans:
                displayResultLabel.text = "\(ansOperandNumber)"
            case .procent:
                if arrayCount > 3 {
                    let arr = showArrayAction[arrayCount - 3...arrayCount - 1]
                    showArrayAction = [lastResult, arr[arrayCount - 3], arr[arrayCount - 2], arr[arrayCount - 1]]
                    showString = showArrayAction.joined()
                }
            }
        }
        showResulsLabel.text = showString
        
        if lastCharEntered == .number, showArrayAction.last != nil {
            displayResultLabel.text = showArrayAction.last
        }
    }
    
    // Method reset all button after you divide by zero + play push button sound
    
    private func errorDivideZero(sender: UIButton) {
        if alert {
            clearALl()
        } else {
            AudioServicesPlaySystemSound(0x450)
        }
    }
    
    private func clearALl() {
        showArrayAction = []
        canceledArrayAction = []
        
        firstOperand = 0
        secondOperand = 0
        currentInput = 0
        displayResultLabel.text = "0"
        showResulsLabel.text = "0"
        stillTyping = false
        operationSign = ""
        pointIsPlace = false
        backspaceNeed = false
        alert = false
        procentMinusOrAns = false
        divideByZero = false
        isRemove = false
        lastCharEntered = .none
    }
}


