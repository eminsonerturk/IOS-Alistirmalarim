//
//  tableVC.swift
//  Travel-Map-Book
//
//  Created by Emin Soner TÜRK on 23.10.2017.
//  Copyright © 2017 Emin Soner TÜRK. All rights reserved.
//

import UIKit
import CoreData

class tableVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
    
    var titleArray = [String]()
    var subtitleArray = [String]()
    var latitudeArray = [Double]()
    var longitudeArray = [Double]()
    
    var selectedTitle = ""
    var selectedSubtitle = ""
    var selectedLatitude : Double = 0
    var selectedLongitude : Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        fetchData()
    }
    
    
    //Burada save butonuna basıldıktan sonra oluşan bir olaymış gibi kullanılmıştır.
    
    //mapVC ekranında back tuşuna basılınca başlatılacak fonksiyondur. Yani backe basınca tableVC.fetchData fonksiyonunu çalıştırıyor.. Eğer bir yenileme olduysa burda bu fonksiyonu kullanacak demektir..
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(tableVC.fetchData), name: NSNotification.Name(rawValue: "newPlace"), object: nil)
    }
    
    
    //Veritabanına kaydedilen verileri çekmek için kullanıldı.
    @objc func fetchData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        request.returnsObjectsAsFaults = false
        
        do{
            
            let results = try context.fetch(request)
            
            //Oluşturduğumuz dizilerimizin içine öncelikle removeAll yaptıktan sonra for döngüsüyle teker teker ekleme yapıyoruz.
            
            if results.count > 0 {
                self.titleArray.removeAll(keepingCapacity: false)
                self.subtitleArray.removeAll(keepingCapacity: false)
                self.latitudeArray.removeAll(keepingCapacity: false)
                self.longitudeArray.removeAll(keepingCapacity: false)
                
                for result in results as! [NSManagedObject] {
                    
                    if let title = result.value(forKey: "name") as?
                        String{
                        self.titleArray.append(title)
                    }
                    if let subtitle = result.value(forKey: "subtitle") as?
                        String{
                        self.subtitleArray.append(subtitle)
                    }
                    if let latitude = result.value(forKey: "latitude") as?
                        Double{
                        self.latitudeArray.append(latitude)
                    }
                    if let longitude = result.value(forKey: "longitude") as?
                        Double{
                        self.longitudeArray.append(longitude)
                    }
                    
                    self.tableView.reloadData()
                }
                
            }
            
        } catch{
            
            print("error")
            
        }
        
    }
    
    
   
    
    //Table view'deki itemlerin sağa kaydırılınca sildirilme işlemini yapmaktadır..
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete
        {
            
            deleteRecords(name: titleArray[indexPath.row])
            
            
            titleArray.remove(at: indexPath.row)
            subtitleArray.remove(at: indexPath.row)
            latitudeArray.remove(at: indexPath.row)
            longitudeArray.remove(at: indexPath.row)
            
            self.tableView.reloadData()
            
        }
    }
    
    
    
    
    
    //ListView içindeki seçilen elemanın bilgilerini alır!!
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        selectedTitle = titleArray[indexPath.row]
        selectedSubtitle = subtitleArray[indexPath.row]
        selectedLatitude = latitudeArray[indexPath.row]
        selectedLongitude = longitudeArray[indexPath.row]
        
        performSegue(withIdentifier: "toMapVC", sender: nil)
    }
    
    
    //Segue başlamadan önce list viewden seçilen itemlerin değerlerini diğer segueye aktarır!!
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMapVC" {
            let destinationVC = segue.destination as! mapVC
            destinationVC.selectedTitle = self.selectedTitle
            destinationVC.selectedSubtitle = self.selectedSubtitle
            destinationVC.selectedLatitude = self.selectedLatitude
            destinationVC.selectedLongitude = self.selectedLongitude
        }
    }
    
    //Tableview ' in eleman sayısını döndüren fonksiyon..
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    //Tableview ' in içinin başlıklarla doldurulmasını sağlayan fonksiyon..
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        cell.textLabel?.text = titleArray[indexPath.row]
        return cell
    }
    
    //Segueler arası geçiş yapmak için kullanılan fonksiyon..
    @IBAction func addButtonClicked(_ sender: Any) {
        
        selectedTitle = ""
        performSegue(withIdentifier: "toMapVC", sender: nil)
    }
    
    
    
    //Veri tabanındaki ismi verilen verinin silinmesi işlemini gerçekleştirmektedir..
    func deleteRecords(name: String) -> Void {
        let moc = getContext()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Places")
        
        let result = try? moc.fetch(fetchRequest)
        let resultData = result as! [Places]
        
        for object in resultData {
            
            if object.name == name {
                print(object.name!)
                moc.delete(object)
            }
            
        }
        
        do {
            try moc.save()
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
    //Context'in alınmasıyla ilgili bir fonksiyon..
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

}
