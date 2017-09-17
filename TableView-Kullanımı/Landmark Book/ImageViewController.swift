//
//  ImageViewController.swift
//  Landmark Book
//
//  Created by Emin Soner TÜRK on 17.09.2017.
//  Copyright © 2017 Emin Soner TÜRK. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    
    @IBOutlet weak var ImageView: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var landmarkName = ""
    var landmarkImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        ImageView.image = landmarkImage
        nameLabel.text = landmarkName
        

    }

    

    

}
