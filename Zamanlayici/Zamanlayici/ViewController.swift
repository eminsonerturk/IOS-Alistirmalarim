//
//  ViewController.swift
//  Zamanlayici
//
//  Created by Emin Soner TÜRK on 16.09.2017.
//  Copyright © 2017 Emin Soner TÜRK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    var timer = Timer()
    var counter = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        counter = 10
        timeLabel.text = String(counter)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.timeFunction), userInfo: nil, repeats: true)
    }


    func timeFunction(){
        
        if(counter < 0){
            timer.invalidate()
            timeLabel.text = "Time's off!"
        }else{
            timeLabel.text = String(counter)
            counter = counter - 1
        }
    }
}

