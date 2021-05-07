//
//  ImageViewController.swift
//  BucketLists
//
//  Created by Chris Harding on 4/1/21.
//

import UIKit

class ImageViewController: UIViewController {
    
    var shouldDelete = false
    
    @IBOutlet weak var image: UIImageView!
    var newImage: UIImage!
    
    override func viewDidLoad() {
        shouldDelete = false
        super.viewDidLoad()
        image.image = newImage
    }
    
    @IBAction func backButton(_ sender: Any) {
        print("Go Back")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteImage(_ sender: Any) {
        shouldDelete = true
        image.image = nil
        dismiss(animated: true, completion: nil)
        
    }
}
