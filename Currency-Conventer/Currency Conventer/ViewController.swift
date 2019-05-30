//
//  ViewController.swift
//  Currency Conventer
//
//  Created by Emin Soner TÜRK on 5.11.2017.
//  Copyright © 2017 Emin Soner TÜRK. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var usdLabel: UILabel!
    
    @IBOutlet weak var cadLabel: UILabel!
    
    @IBOutlet weak var chfLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        getCurrency(currency: searchBar.text!)
        searchBar.text = ""
    }
    
    func getCurrency(currency: String){
        
        let url = URL(string: "http://api.fixer.io/latest?base=\(currency)")
        let session = URLSession.shared
        
        let task = session.dataTask(with: url!) { (data, response, error) in
            
            if error != nil{
                let alert = UIAlertController(title: "error", message: error?.localizedDescription, preferredStyle: UIAlertControllerStyle.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler:nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                
                if data != nil{
                    
                    do{
                        
                       let jSONResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String,AnyObject>
                        
                        //async fonksiyonu paralel programlamada runnable komutuyla aynı işlevi görmektedir. Yani asenkron yeni bir threat işlemi yaratır.
                        DispatchQueue.main.async {
                            print(jSONResult)
                            
                            print(jSONResult["rates"] as Any)
                            
                            let rates = jSONResult["rates"] as! [String: AnyObject]
                            
                            let usd = String(describing: rates["USD"]!)
                            self.usdLabel.text = "USD: \(usd)"
                            
                            let cad = String(describing: rates["CAD"]!)
                            self.cadLabel.text = "CAD: \(cad)"
                            
                            let chf = String(describing: rates["CHF"]!)
                            self.chfLabel.text = "CHF: \(chf)"
                            
                        }

                        
                    
                    }catch{
                        
                    }
                    
                    
                }
                
                
                
            }
            
            
         }
        task.resume()
        
        
    }

}

