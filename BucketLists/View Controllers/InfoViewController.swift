//
//  InfoViewController.swift
//  BucketLists
//
//  Created by Jake Olsen on 3/26/21.
//

import UIKit

class InfoViewController: UIViewController, UIImagePickerControllerDelegate , UICollectionViewDelegate, UINavigationControllerDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = self.imageArray[indexPath.row]
        return cell
    }
    
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var sections = [Section]()
    
    enum Section: Hashable {
        case photos
    }
    
    var imageArray = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = UIImage(systemName: "camera") {
            imageArray.append(image)
            
        }
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        // Do any additional setup after loading the view.
        //        configureDataSource()
    }
    @IBAction func addImageButton(_ sender: UIButton) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imageArray.append(selectedImage)
        dismiss(animated: true, completion: nil)
        imageCollectionView.reloadData()
        //        dataSource.apply()
    }
    
}
