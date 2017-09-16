//
//  ViewController.swift
//  Colors
//
//  Created by Emin Soner TÜRK on 16.09.2017.
//  Copyright © 2017 Emin Soner TÜRK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.green
    }


    @IBAction func WhiteClicked(_ sender: Any) {
        
        view.backgroundColor = UIColor.white
    }
    
    
    @IBAction func BlackClicked(_ sender: Any) {
        
        view.backgroundColor = UIColor.black
    }
    
    
    @IBAction func MagentaClicked(_ sender: Any) {
        
        view.backgroundColor = UIColor.magenta
    }
    
    
    @IBAction func PurpleClicked(_ sender: Any) {
        
        view.backgroundColor = UIColor.purple
    }
    
    @IBAction func GreyClicked(_ sender: Any) {
        
        view.backgroundColor = UIColor.gray
    }
    
    @IBAction func YellowClicked(_ sender: Any) {
        
        view.backgroundColor = UIColor.yellow
    }
    
    
    
}


