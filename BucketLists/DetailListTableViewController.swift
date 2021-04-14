//
//  DetailListTableViewController.swift
//  BucketLists
//
//  Created by Chris Harding on 3/19/21.
//

import UIKit

class DetailListTableViewController: UITableViewController, UIImagePickerControllerDelegate, UICollectionViewDelegate, UINavigationControllerDelegate, UICollectionViewDataSource {

   
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var completionSwitch: UISwitch!
    @IBOutlet var doneLabel: UIBarButtonItem!
    
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    
    var bucketLists: [BucketList] = []
    var indexOfBucketList: Int = 0
    var indexOfItem: Int = 0
    var dataController = DataController()
    var item: Item?
    var editMode: Bool = false
    var globalIndex: Int = 0
    
    //Added code begins
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        imageArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = imageCollectionView.dequeueReusableCell(withReuseIdentifier: "pictureCell", for: indexPath) as! ImageCollectionViewCell
                        cell.imageView.image = self.imageArray[indexPath.row]
                        return cell
    }
    
    var sections = [Section]()
    
    enum Section: Hashable {
        case photos
    }
    var imageArray = [UIImage]()
    var imageStringArray = [String]()
    //Added Code ends
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        descriptionTextView.isUserInteractionEnabled = false
        updateItem(item: item)
        
        if let image = UIImage(systemName: "") {
            
        imageArray.append(image)
        
        }
        if let newImageStringArray = item?.imageArray {
            imageStringArray = newImageStringArray
        }
        for items in imageStringArray {
            print(items)
            if let newImage = loadImageFromDiskWith(fileName: items){
            imageArray.append(newImage)
            }
        }
        
        imageCollectionView.delegate = self
        imageCollectionView.dataSource = self
        
        descriptionTextField.clipsToBounds = true
        descriptionTextField.layer.cornerRadius = 10.0
        descriptionTextField.layer.borderWidth = 1
        descriptionTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        descriptionTextView.clipsToBounds = true
        descriptionTextView.layer.cornerRadius = 10.0
        descriptionTextView.layer.borderWidth = 0
        descriptionTextView.layer.borderColor = UIColor.lightGray.cgColor
        if descriptionTextField.text == "Describe your experience" {
            descriptionTextField.layer.borderWidth = 1
            descriptionTextField.isUserInteractionEnabled = true
        } else {
            descriptionTextField.layer.borderWidth = 0
            descriptionTextField.isUserInteractionEnabled = false

        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if completionSwitch.isOn == true {
            return 6
        } else {
        return  5
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func updateItem(item: Item?) {
        guard let item = item else {return}
        nameLabel.text = item.name
        descriptionTextView.text = item.description
        locationLabel.text = item.location
        datePicker.date = item.goalDate
        completionSwitch.isOn = item.isComplete
        descriptionTextField.text = item.details
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        globalIndex = indexPath.row
        print(globalIndex)
        performSegue(withIdentifier: "imageSegue", sender: nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "detailUnwind" {
            
        guard segue.identifier == "detailUnwind" else {return}
        let name = nameLabel.text ?? ""
        let description = descriptionTextView.text ?? ""
        let location = locationLabel.text ?? ""
        let goalDate = datePicker.date
        let completed = completionSwitch.isOn
        let details = descriptionTextField.text ?? ""
            item = Item(name: name, description: description, location: location, goalDate: goalDate, isComplete: completed, details: details, imageArray: imageStringArray)
        }
//      bucketLists[indexOfBucketList].items[indexOfItem] = item!
//      dataController.saveData(lists: bucketLists)
        else if segue.identifier == "imageSegue" {
        guard segue.identifier == "imageSegue" else {return}
        let destination = segue.destination as! ImageViewController
        let newImage = imageArray[globalIndex]
        destination.newImage = newImage
        }
    }

    @IBAction func editButton(_ sender: Any) {
        if editMode == false {
            nameLabel.isUserInteractionEnabled = true
            descriptionTextView.isUserInteractionEnabled = true
            locationLabel.isUserInteractionEnabled = true
            datePicker.isUserInteractionEnabled = true
            descriptionTextField.isUserInteractionEnabled = true
            
            nameLabel.borderStyle = UITextField.BorderStyle.roundedRect
//          descriptionLabel.borderStyle = UITextField.BorderStyle.roundedRect
            descriptionTextView.layer.borderWidth = 1
            locationLabel.borderStyle = UITextField.BorderStyle.roundedRect
            descriptionTextField.layer.borderWidth = 1

            editMode = true
        }
        else if editMode == true {
            nameLabel.isUserInteractionEnabled = false
            descriptionTextView.isUserInteractionEnabled = false
            locationLabel.isUserInteractionEnabled = false
            datePicker.isUserInteractionEnabled = false
            descriptionTextField.isUserInteractionEnabled = false
            
            nameLabel.borderStyle = UITextField.BorderStyle.none
//          descriptionLabel.borderStyle = UITextField.BorderStyle.none
            descriptionTextView.layer.borderWidth = 0
            locationLabel.borderStyle = UITextField.BorderStyle.none
            descriptionTextField.layer.borderWidth = 0
            
            editMode = false
        }
    }
   // override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       // if indexPath.row == 2 {
       //     return 512
       // } else{
       //     return UITableView.automaticDimension
       // }
   // }
     @IBAction func CompletionSwitch(_ sender: Any) {
        tableView.reloadData()
     }
    
    
    @IBAction func editingChanged(_ sender: Any) {
        if nameLabel.text?.count != 0 {
            doneLabel.isEnabled = true
        } else {
            doneLabel.isEnabled = false
        }
    }
    @IBAction func addImageButton(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    func deleteimage () {
        imageArray.remove(at: globalIndex)
        imageStringArray.remove(at: globalIndex)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        imageArray.append(selectedImage)
        dismiss(animated: true, completion: nil)
        let uid = UUID()
        imageStringArray.append("\(uid)")
        saveImage(imageName: "\(uid)", image: selectedImage)
        print("image name", selectedImage)
        imageCollectionView.reloadData()
        //dataSource.apply()
    }
    func saveImage(imageName: String, image: UIImage) {

     guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }

        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }

        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file", error)
        }

    }
    func loadImageFromDiskWith(fileName: String) -> UIImage? {

      let documentDirectory = FileManager.SearchPathDirectory.documentDirectory

        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)

        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image

        }
        return nil
    }
    @IBAction func unwind(segue: UIStoryboardSegue) {
        print("Unwind worked")
        if segue.identifier == "deleteImage" {
            deleteimage()
            imageCollectionView.reloadData()
        }
    }
}
