//
//  ViewController.swift
//  Travel-Map-Book
//
//  Created by Emin Soner TÜRK on 22.10.2017.
//  Copyright © 2017 Emin Soner TÜRK. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class mapVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var nameText: UITextField!
    @IBOutlet weak var commandText: UITextField!
    
    
    //Kullanıcının lokasyon bilgisini almak için kullanılan fonksiyon
    var locationManager = CLLocationManager()
    
    var requestCLLocation = CLLocation()
    
    var chosenLatitude = Double()
    var chosenLongitude = Double()
    
    var selectedTitle = ""
    var selectedSubtitle = ""
    var selectedLatitude : Double = 0
    var selectedLongitude : Double = 0
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        //Bolum 12 ders 103..
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        //Bulunulan noktayı 3 saniye basınca pinlemesi için olmuşturulmuşlardır.
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(mapVC.chooseFunction(gestureRecognize:)))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
        
        
        //Add button değilde bişey seçilerek geldiyse bu işlemleri yapacaktır.
        if selectedTitle != "" {
            let annotation = MKPointAnnotation()
            
            let coordinate = CLLocationCoordinate2DMake(self.selectedLatitude, self.selectedLongitude)
            
            annotation.coordinate = coordinate
            
            annotation.title = self.selectedTitle
            annotation.subtitle = self.selectedSubtitle
            
            self.mapView.addAnnotation(annotation)
            
            nameText.text = self.selectedTitle
            commandText.text = self.selectedSubtitle
            
            
        }
        
    }
    
    @objc func chooseFunction(gestureRecognize: UILongPressGestureRecognizer){
        if gestureRecognize.state == UIGestureRecognizerState.began{
            let touchedPoint = gestureRecognize.location(in: self.mapView)
            let choosenCoordinates = self.mapView.convert(touchedPoint, toCoordinateFrom: self.mapView)
            
            
            chosenLatitude = choosenCoordinates.latitude
            chosenLongitude = choosenCoordinates.longitude
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = choosenCoordinates
            
            annotation.title = nameText.text
            
            annotation.subtitle = commandText.text
            
            self.mapView.addAnnotation(annotation)
        }
    }
    
    //Lokasyon yaratma fonksiyonu.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = CLLocationCoordinate2DMake(locations[0].coordinate.latitude, locations[0].coordinate.longitude)
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        
        let region = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: true)
    }
    
    
    //Anotasyonların belli başlı fonksiyonlarını pinleri özelleştirmek için kullanıyoruz.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        //Eğer kullanıcının kendi konumuyla alakalı bir anotasyonsa hiç bir şey yapma..
        if annotation is MKUserLocation{
            return nil
        }
        
        
        //PinView'ın özelleştirilmesi(siyah görünmesi) işlemi yapıldı ve yanına ("i") butonu eklendi.
        let reuseID = "myAnnotation"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            
            pinView?.canShowCallout = true
            pinView?.pinTintColor = UIColor.black
            
            let button = UIButton(type: UIButtonType.detailDisclosure)
            pinView?.rightCalloutAccessoryView = button
            
        } else{
            
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    
    //Lokasyonun yanındaki ("i") butonuna basılması sonucu oluşan aktivasyon işlemleriyle ilgili işlemler yapılmıştır.
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        
        // Önce seçilmiş latitude ve longitude değeri olup olmadığına bakıyoruz. Yoksa sistemi çökertebiliriz..
        if selectedLatitude != 0 {
            if selectedLongitude != 0 {
                self.requestCLLocation = CLLocation(latitude: selectedLatitude, longitude: selectedLongitude)
            }
        }
        
        //Oluşturduğum locationdan adres bul demek Geocoder.. Enlem ve boylam ile location oluşturuyorsun. Bu enlem ve boylam ile adres alabiliyorsun bu işe yaramaktadır.
        CLGeocoder().reverseGeocodeLocation(requestCLLocation) { (placemarks, error) in
            
            if let placemark = placemarks {
                
                //Eğer o adresi alabilirsem
                if placemark.count > 0 {
                    
                    //O adresten ilk olanını alıyorum..
                    let newPlacemark = MKPlacemark(placemark: placemark[0])
                    let item = MKMapItem(placemark: newPlacemark)
                    item.name = self.selectedTitle
                    
                    //Ve o adrese giden bir navigasyon almaya çalışıyorum..
                    let launchOptions = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
                    
                    item.openInMaps(launchOptions: launchOptions)
                }
            }
        }
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    //Veri tabanıyla ilgili işlemlerin yapıldığı fonksiyon. Yer adı, yorum, enlem ve boylam değerleri alınarak core dataya yazdırılma işlemleri yapılmıştır.
    @IBAction func saveButtonClicked(_ sender: Any) {
    
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        
        let newPlace = NSEntityDescription.insertNewObject(forEntityName: "Places", into: context!)
        
        newPlace.setValue(nameText.text, forKey: "name")
        newPlace.setValue(commandText.text, forKey: "subtitle")
        newPlace.setValue(chosenLatitude, forKey: "latitude")
        newPlace.setValue(chosenLongitude, forKey: "longitude")
        
        do{
            try context?.save()
            print("saved")
            
            
        } catch {
            print("error")
            
        }
        
        
        //Back tuşuna basılınca oluşacak olaylar burada yazılmıştır.. Save tuşuna basınca bir önceki sayfaya dönücektir.
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "newPlace"), object: nil)
        
        self.navigationController?.popViewController(animated: true)
    
    }
    

}

