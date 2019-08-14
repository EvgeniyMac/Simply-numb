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
