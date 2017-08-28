//
//  ViewController.swift
//  Test1
//
//  Created by Emin Soner TÜRK on 12.08.2017.
//  Copyright © 2017 Emin Soner TÜRK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var saatEtiket: UILabel!
    @IBOutlet weak var tarihEtiketi: UILabel!

    
    var sayac = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        sayac = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(self.guncelle)), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func guncelle (){
        
        let saatFormater = DateFormatter()
        saatFormater.timeStyle = .medium
        saatFormater.locale = Locale.init(identifier: "tr-TR")
        
        let tarihFormater = DateFormatter()
        tarihFormater.dateStyle = .medium
        tarihFormater.locale = Locale.init(identifier: "tr-TR")
        
        saatEtiket.text = saatFormater.string(from: Date())
        tarihEtiketi.text = tarihFormater.string(from: Date())
        
    }

    
   }

