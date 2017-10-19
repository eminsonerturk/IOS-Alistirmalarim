//
//  detailsVC.swift
//  Art Book
//
//  Created by Emin Soner TÜRK on 8.10.2017.
//  Copyright © 2017 Emin Soner TÜRK. All rights reserved.
//

import UIKit
import Photos
import CoreData

class detailsVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var artistText: UITextField!
    @IBOutlet weak var yearText: UITextField!
    var chosenPainting = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if chosenPainting != "" {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Paintings")
            
            //İsmin self.chosenPainting'e eşit olduğu bir durum varsa bana bunu bul demek. ViewController class'ın dan buraya geçerken veri aktarımı yapıldığı için böyle bir değer aldık..
            fetchRequest.predicate = NSPredicate(format: "name = %@", self.chosenPainting)
            fetchRequest.returnsObjectsAsFaults = false
            
            do{
                let results = try context.fetch(fetchRequest)
                
                if (results.count > 0){
                    
                    for result in results as! [NSManagedObject]{
                        
                        if let name = result.value(forKey: "name") as? String {
                            
                            nameText.text = name
                        }
                        
                        if let year = result.value(forKey: "year") as? Int {
                            
                            yearText.text = String(year);
                        }
                        
                        if let artist = result.value(forKey: "artist") as? String {
                            
                            artistText.text = artist
                        }
                        
                        if let imageData = result.value(forKey: "image") as? Data {
                            
                            let image = UIImage(data: imageData)
                            
                            self.imageView.image = image
                            
                        }
                        
                    }
                }
            }catch{
                print("error")
            }
        }
        
        //Image üzerinde oynama yapabilmek için yapılan ayarlar.
        
        imageView.isUserInteractionEnabled = true
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(detailsVC.selectImage))
        
        imageView.addGestureRecognizer(gestureRecognizer)
    }

    
    //AppDelegate.swift dosyasının içindeki Core Datayla ilgili fonksiyonları kullanarak veritabanı işlemlerini yapar.
    @IBAction func saveButtonClicked(_ sender: Any) {
        
        
        //Core dataya veri eklemek için önce appDelegate oluşturularak AppDelegate.swift dosyasının içindeki Core Datayla ilgili işlem yapmak için arayüz oluşturuldu.
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        // Bu arayüz aracılığıyla core datamıza bağlama işlemi yapılıyor.
        //Art_Book.xcdatamodeld içindeki core dataya veri aktarımı yapılıyor.
        let newArt = NSEntityDescription.insertNewObject(forEntityName: "Paintings", into: context)
        
        //Core dataya (veritabanına) veri ekleme işlemi yapılıyor.
        newArt.setValue(nameText.text, forKey: "name")
        newArt.setValue(artistText.text, forKey: "artist")
        
        //if let komutu --> bunu yapmayı becerebilirsen anlamına gelmektedir.
        if let year = Int(yearText.text!){
            newArt.setValue(year, forKey: "year")
        }
        
        //Veritabanına görüntüyü kaydedebilmek için dataya çevirmek zorundayız. UIImageJPEGRepresentation fonksiyonu bu işlemi bizim yerimize yapmaktadır. Bu fonksiyon şu anda belirtilen resmi yarı boyutuna indirerek sıkıştırır ve dataya çevirir.
        let data = UIImageJPEGRepresentation(imageView.image!, 0.5)
        
        newArt.setValue(data, forKey: "image")
        
        //Bu işlemleri yaptıktan sonra context'i save etmemiz gerekmektedir. Throw işlemlerinde try catch işlemleri yapmamız gerekmektedir. Çünkü bu işlemin save edilip edilmeyeceği garanti değildir.
        
        do{
            try context.save()
            print("succesful")
        } catch{
            print("error")
        }
        
        
        //popViewController bulunduğundan bir öncekine git demek.. ve newPainting postuyla viewControllerdaki viewWillAppear fonksiyonuna gönderilmiştir. 
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue:"newPainting"), object: nil)
        
        self.navigationController?.popViewController(animated: true)
        
        
        
    }
    
    //Telefon kütüphanesinden herhangi bir image seçmek için kullanılan method.
    
    @objc func selectImage(){
        
       //İlgili sorunun çözüleceği kısım burası..
        // checkPhotoLibraryPermission()
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
        
        
    }
    
    //İmage view kütüphaneden seçildikten sonra ilgili imaj atandı ve ekran kapandı.
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imageView.image = info[UIImagePickerControllerEditedImage]  as? UIImage
        self.dismiss(animated: true, completion: nil)
        
    }
    
    
    //Kullanıcıdan izin almak için oluşturulmuş (zevk için) ek fonksiyon.
    func checkPhotoLibraryPermission() {
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .authorized:
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        //handle authorized status
            break
        case .denied, .restricted :
        //handle denied status
            
            break
        case .notDetermined:
            // ask for permissions
            PHPhotoLibrary.requestAuthorization() { status in
                switch status {
                case .authorized:
                // as above
                    break
                case .denied, .restricted:
                // as above
                    break
                case .notDetermined:
                    // won't happen but still
                    break
                }
            }
        }
    }
    
    
    
    
    
    
    
}


    //Image işlemleri yapıldıktan sonra info.plist'ten kütüphane iznini tanımladık. Sağ tuş privacy- photo library diyerek ilgili izin cümlesini hemen sağ satırında yazdık.

