//
//  ButtonExtension.swift
//  Simply numb
//
//  Created by Evgeniy Suprun on 8/12/19.
//  Copyright © 2019 Evgeniy Suprun. All rights reserved.
//

import UIKit



extension UIButton {
    
    override open var isHighlighted: Bool {
        didSet {
            backgroundColor = isHighlighted ? UIColor(red: 158 / 255, green: 123 / 255, blue: 91 / 255, alpha: 0.5) : UIColor(red: 77 / 255, green: 60 / 255, blue: 44 / 255, alpha: 1.0)
        }
    } 
}

extension Double {
    func roundToDecimal(_ fractionDigits: Int) -> Double {
        let multiplier = pow(10, Double(fractionDigits))
        return Darwin.round(self * multiplier) / multiplier
    }
}

extension UIView {
    
    func gradientBackgroundColor() {
        
        let color1 = UIColor(red: 100 / 255, green: 67 / 255, blue: 41 / 255, alpha: 1.0).cgColor
        let color2 = UIColor(red: 42 / 255, green: 30 / 255, blue: 16 / 255, alpha: 1.0).cgColor
        let deviceScale = UIScreen.main.scale
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0.0, y: 1.0, width: self.frame.size.width * deviceScale, height: self.frame.size.height * deviceScale)
        gradient.colors = [color1, color2]
        gradient.locations = [0.0, 0.3]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 0.0, y: 1.0)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
}

extension String {
    
    func removeCharsFromEnd(count:Int) -> String{
        let stringLength = self.count
        
        let substringIndex = (stringLength < count) ? 0 : stringLength - count
        
        let index: String.Index = self.index(self.startIndex, offsetBy: substringIndex)
        
        return String(self[..<index])
    }
    
    func length() -> Int {
        return self.count
    }
}


