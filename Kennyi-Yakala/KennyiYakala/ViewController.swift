//
//  ViewController.swift
//  KennyiYakala
//
//  Created by Emin Soner TÜRK on 16.09.2017.
//  Copyright © 2017 Emin Soner TÜRK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var skorLabel: UILabel!
    @IBOutlet weak var HighScoreLabel: UILabel!
    
    @IBOutlet weak var kenny1: UIImageView!
    @IBOutlet weak var kenny2: UIImageView!
    @IBOutlet weak var kenny3: UIImageView!
    @IBOutlet weak var kenny4: UIImageView!
    @IBOutlet weak var kenny5: UIImageView!
    @IBOutlet weak var kenny6: UIImageView!
    @IBOutlet weak var kenny7: UIImageView!
    @IBOutlet weak var kenny8: UIImageView!
    @IBOutlet weak var kenny9: UIImageView!
    
    var score = 0
    var timer = Timer()
    var counter = 0
    var kennyArray = [UIImageView] ()
    var hideTimer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        HighScoreLabel.text="0"
        
        let highScore = UserDefaults.standard.object(forKey: "highscore")
        
        if(highScore == nil){
            HighScoreLabel.text = "0"
        }
        
        if let newScore = highScore as? Int{
            HighScoreLabel.text = String(newScore)
        }
        
        skorLabel.text = "Score: \(score)"
        
        let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(ViewController.increaseScore))
         let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(ViewController.increaseScore))
         let recognizer3 = UITapGestureRecognizer(target: self, action: #selector(ViewController.increaseScore))
         let recognizer4 = UITapGestureRecognizer(target: self, action: #selector(ViewController.increaseScore))
         let recognizer5 = UITapGestureRecognizer(target: self, action: #selector(ViewController.increaseScore))
         let recognizer6 = UITapGestureRecognizer(target: self, action: #selector(ViewController.increaseScore))
         let recognizer7 = UITapGestureRecognizer(target: self, action: #selector(ViewController.increaseScore))
         let recognizer8 = UITapGestureRecognizer(target: self, action: #selector(ViewController.increaseScore))
         let recognizer9 = UITapGestureRecognizer(target: self, action: #selector(ViewController.increaseScore))
        
        kenny1.isUserInteractionEnabled = true
        kenny2.isUserInteractionEnabled = true
        kenny3.isUserInteractionEnabled = true
        kenny4.isUserInteractionEnabled = true
        kenny5.isUserInteractionEnabled = true
        kenny6.isUserInteractionEnabled = true
        kenny7.isUserInteractionEnabled = true
        kenny8.isUserInteractionEnabled = true
        kenny9.isUserInteractionEnabled = true
        
        
        kenny1.addGestureRecognizer(recognizer1)
        kenny2.addGestureRecognizer(recognizer2)
        kenny3.addGestureRecognizer(recognizer3)
        kenny4.addGestureRecognizer(recognizer4)
        kenny5.addGestureRecognizer(recognizer5)
        kenny6.addGestureRecognizer(recognizer6)
        kenny7.addGestureRecognizer(recognizer7)
        kenny8.addGestureRecognizer(recognizer8)
        kenny9.addGestureRecognizer(recognizer9)
        
        //timers
        
        counter = 30
        timeLabel.text = "\(counter)"
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.countDown), userInfo: nil, repeats: true)
        
        hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ViewController.hideKenny), userInfo: nil, repeats: true)
        
        kennyArray.append(kenny1)
        kennyArray.append(kenny2)
        kennyArray.append(kenny3)
        kennyArray.append(kenny4)
        kennyArray.append(kenny5)
        kennyArray.append(kenny6)
        kennyArray.append(kenny7)
        kennyArray.append(kenny8)
        kennyArray.append(kenny9)
        
        hideKenny()

    }
    
    
    @objc func hideKenny(){
        
        
        
        
        for kenny in kennyArray{
            kenny.isHidden = true
        }
        
        let random = Int(arc4random_uniform(UInt32(kennyArray.count - 1)))
        
        kennyArray[random].isHidden = false
    }

    @objc func increaseScore(){
        skorLabel.text = "Score: \(score)"
        score = score + 1
    }
    
    @objc func countDown(){
        counter = counter - 1
        timeLabel.text = "\(counter)"
        
        if(counter==0){
            timer.invalidate()
            hideTimer.invalidate()
            
            
            
            if self.score > Int(HighScoreLabel.text!)! {
                
                UserDefaults.standard.set(self.score, forKey: "highscore")
                HighScoreLabel.text = String(self.score)
                
            }
            
            for kenny in kennyArray{
                kenny.isHidden = true
            }

            
            
            let alert = UIAlertController(title: "Oyun Bitti..", message: "Zamanınız Doldu!", preferredStyle: UIAlertControllerStyle.alert)
            
            let okButton = UIAlertAction(title: "Tamam", style: UIAlertActionStyle.default, handler: nil)
            
            let yenidenOynaButton = UIAlertAction(title: "Yeniden Oyna", style: UIAlertActionStyle.default, handler: { (UIAlertAction) in
                
                self.score = 0
                self.skorLabel.text = "Skor: \(self.score)"
                self.counter = 30
                self.timeLabel.text = "\(self.counter)"
                
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.countDown), userInfo: nil, repeats: true)
                
                self.hideTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(ViewController.hideKenny), userInfo: nil, repeats: true)
                
            })
            
            alert.addAction(okButton)
            alert.addAction(yenidenOynaButton)
            
            self.present(alert, animated: true, completion: nil)
        }
    }


}

