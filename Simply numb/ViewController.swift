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

    override func viewDidLoad() {
        super.viewDidLoad()
         view.gradientBackgroundColor()
    }
    
    // Change status bar color
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // Make botton layer with gradient
    
    @IBAction func AcButtonTapped(_ sender: UIButton) {
      //   AudioServicesPlaySystemSound(0x450)
    }
    
}



