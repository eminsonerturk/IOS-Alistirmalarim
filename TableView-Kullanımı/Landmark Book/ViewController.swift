//
//  ViewController.swift
//  Landmark Book
//
//  Created by Emin Soner TÜRK on 17.09.2017.
//  Copyright © 2017 Emin Soner TÜRK. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var TableView: UITableView!
    
    var landmarkNames = [String]()
    var landmarkImages = [UIImage]()
    var selectedLandmarkName = ""
    var selectedLandmarkImage = UIImage()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        TableView.dataSource = self
        TableView.delegate = self
        
        
        landmarkNames.append("Colloseum")
        landmarkNames.append("Great Wall")
        landmarkNames.append("Kremlin")
        landmarkNames.append("Stone Hange")
        landmarkNames.append("Taj Mahal")
        
        
        landmarkImages.append(UIImage(named : "colloseum.jpg")!)
        landmarkImages.append(UIImage(named : "great_wall.jpg")!)
        landmarkImages.append(UIImage(named : "kremlin.jpg")!)
        landmarkImages.append(UIImage(named : "stone_hange.jpg")!)
        landmarkImages.append(UIImage(named : "taj_mahal.jpg")!)


        
        
    }
    
    
    //Table view elemanının satır sayısını döndürür.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return landmarkNames.count
    }
    
    
    //Segue için hazırlık yapıldı ve resim ile mekan ismi sonraki segueye yollandı.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toImageVC"{
            
            let destinationVC = segue.destination as! ImageViewController
            
            destinationVC.landmarkName = selectedLandmarkName
            
            destinationVC.landmarkImage = selectedLandmarkImage
            
        }
    }
    
    
    
    //Seçilen satırın ilgili bilgilerini aldıktan sonra segueyi başlatır.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedLandmarkName = landmarkNames[indexPath.row]
        
        selectedLandmarkImage = landmarkImages[indexPath.row]
        
        
        performSegue(withIdentifier: "toImageVC", sender: nil)
        
    }
    
    
    //Delete işlemleri burada yapılıyor.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            landmarkNames.remove(at: indexPath.row)
            landmarkImages.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
    }
    
    //Table view elemanının ilgili satırda ilgili işlemi yapması sağlanır.
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = landmarkNames[indexPath.row]
        return cell
    }

    
    
}

