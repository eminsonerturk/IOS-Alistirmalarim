//
//  ViewController.swift
//  Art Book
//
//  Created by Emin Soner TÜRK on 26.09.2017.
//  Copyright © 2017 Emin Soner TÜRK. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet weak var tableView: UITableView!
    
    var nameArray = [String]()
    var yearArray = [Int]()
    var artistArray = [String]()
    var imageArray = [UIImage]()
    var selectedPainting = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Get info fonksiyonu program başlatılırken çağırıldı.
        getInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        // Ana(Açılış ekranı) ekran her açıldığında bu fonksiyon çağırılıcaktır.
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.getInfo), name: NSNotification.Name(rawValue: "newPainting"), object: nil)
    }
    
    
    func getInfo(){
        
        //Array içindeki tüm bilgileri boşaltıyoruz.
        nameArray.removeAll(keepingCapacity: false)
        yearArray.removeAll(keepingCapacity: false)
        imageArray.removeAll(keepingCapacity: false)
        artistArray.removeAll(keepingCapacity: false)
        
        //Core dataya bağlanabilmek için yine context ile arayüz oluşturmak zorunda kalıyoruz.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        //Core datadan veri çekmek için fetchRequest oluşturduk.
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
        //Verileri listelemek için bu özelliği false yapmak zorundayız.
        fetchRequest.returnsObjectsAsFaults = false
        
        
        //Core data içindeki verilerin çekilme işlemi yapılıyor..
        do{
           let results = try context.fetch(fetchRequest)
            
            
            if (results.count > 0){
                for result in results as! [NSManagedObject]{
                    
                    if let name = result.value(forKey: "name") as? String{
                        self.nameArray.append(name)
                    }
                    
                    if let year = result.value(forKey: "year") as? Int{
                        self.yearArray.append(year)
                    }
                    
                    if let artist = result.value(forKey: "artist") as? String{
                        self.artistArray.append(artist)
                    }
                    
                    if let imageData = result.value(forKey: "image") as? Data{
                        let image = UIImage(data: imageData)
                        self.imageArray.append(image!)
                    }
                    
                    self.tableView.reloadData()
                    
                }
            }
            
        } catch{
            print("error")
        }
        
        
    }
    
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int
    {
        return nameArray.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = nameArray[indexPath.row]
        
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailsVC" {
            let destinationVC = segue.destination as! detailsVC
            
            destinationVC.chosenPainting = selectedPainting
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedPainting = nameArray[indexPath.row]
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
    }

    @IBAction func addButtonClicked(_ sender: Any) {
        
        selectedPainting = ""
        performSegue(withIdentifier: "toDetailsVC", sender: nil)
        
        
    }
    
    
    
    
    
    
    
    func CoreDataTemizle(){
        
        // CoreData temizlemeye yarayan fonksiyon..
        
        
        // create the delete request for the specified entity
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            //CoreData ismi buraya yazılacak.
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        // get reference to the persistent container
        let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        
        // perform the delete
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            print(error)
        }
        //

    }
    
    
    
    
}

