//
//  UIViewExtension.swift
//  Simply numb
//
//  Created by Evgeniy Suprun on 8/12/19.
//  Copyright © 2019 Evgeniy Suprun. All rights reserved.
//

import Foundation
import UIKit

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
