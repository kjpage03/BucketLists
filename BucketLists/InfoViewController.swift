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
    
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    var sections = [Section]()
    
    enum Section: Hashable {
        case photos
    }
    var imageArray = [UIImage]()
    
//    var dataSource: UICollectionViewDiffableDataSource<Section, Item>!
//
    override func viewDidLoad() {
        super.viewDidLoad()
        if let image = UIImage(systemName: "calendar") {
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
    
//    func configureDataSource() {
//        dataSource = .init(collectionView: imageCollectionView, cellProvider: { (imageCollectionView, indexPath, item) -> UICollectionViewCell? in let section = self.sections[indexPath.section]
//            switch section {
//            case .photos:
//                let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as! ImageCollectionViewCell
//                cell.imageView.image = self.imageArray[indexPath.row]
//                return cell
//            }
//        })
//    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imageArray.append(selectedImage)
        dismiss(animated: true, completion: nil)
        imageCollectionView.reloadData()
//        dataSource.apply()
            }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
