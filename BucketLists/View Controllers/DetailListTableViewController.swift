//
//  DetailListTableViewController.swift
//  BucketLists
//
//  Created by Chris Harding on 3/19/21.
//

import UIKit
import MapKit

class DetailListTableViewController: UITableViewController, UIImagePickerControllerDelegate, UICollectionViewDelegate, UINavigationControllerDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet var descriptionTextView: UITextView!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var completionSwitch: UISwitch!
    @IBOutlet var doneLabel: UIBarButtonItem!
    @IBOutlet var editButton: UIBarButtonItem!
    @IBOutlet weak var descriptionTextField: UITextView!
    @IBOutlet var setLocationButton: UIButton!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var goalSwitch: UISwitch!
    var matchingItems:[MKMapItem] = []
    var selectedPin: MKPlacemark? = nil
    let locationManager = CLLocationManager()
    var bucketLists: [BucketList] = []
    var indexOfBucketList: Int = 0
    var indexOfItem: Int = 0
    var dataController = DataController()
    var saveLoadImage = SaveLoadImage()
    var item: Item?
    var editMode: Bool = false
    @IBOutlet var collectionViewHeight: NSLayoutConstraint!
    var originalHeight: CGFloat?
    
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
        mapView.layer.cornerRadius = 10
        tableView.allowsSelection = false
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        descriptionTextView.isUserInteractionEnabled = false
        updateItem(item: item)
        originalHeight = collectionViewHeight.constant
        activityIndicator.isHidden = true
        //        if let image = UIImage(systemName: "photo") {
        //        imageArray.append(image)
        //
        //        }
        
        if item?.goalDate == nil {
            goalSwitch.isOn = false
            datePicker.isHidden = true
        } else {
            goalSwitch.isOn = true
            datePicker.isHidden = false
        }
        
        if let image = UIImage(systemName: "") {
            imageArray.append(image)
        }
        
        for items in imageStringArray {
            print(items)
            if let newImage = saveLoadImage.loadImageFromDiskWith(fileName: items){
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
        
        descriptionTextField.layer.borderWidth = 1
        descriptionTextField.isUserInteractionEnabled = false
        
        //        let string = NSMutableAttributedString(string: "Add Image")
        //
        //        let imageAttachment = NSTextAttachment()
        //        imageAttachment.image = UIImage(systemName: "photo")
        //        let imageString = NSAttributedString(attachment: imageAttachment)
        //        string.append(imageString)
        
    }
    
    // MARK: - Table view data source
    
    override func viewWillAppear(_ animated: Bool) {
        resizeCollectionView()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if completionSwitch.isOn == true {
            return 6
        } else {
            return 4
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
//        if indexPath.section == 2 {
//            if item?.goalDate == nil {
//            return 0
//            } else {
//            return super.tableView(tableView, heightForRowAt: indexPath)
//            }
//        }
        
        if imageArray.count == 0 && indexPath.section == 4 {
            return 487 - originalHeight!
        } else if imageArray.count > 0 && indexPath.section == 4 {
            return 487
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    func updateItem(item: Item?) {
        guard let item = item else {return}
        nameLabel.text = item.name
        descriptionTextView.text = item.description
        //        locationLabel.text = item.location
        if let coordinate = item.location {
            //            dropPinZoomIn(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(coordinate[0])!, longitude: CLLocationDegrees(coordinate[1])!)))
            dropPinZoomIn(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(coordinate.latitude)!, longitude: CLLocationDegrees(coordinate.longitude)!)), location: coordinate.location)
        }
        
        //Next Project
        
        datePicker.date = item.goalDate ?? Date()
        
        completionSwitch.isOn = item.isComplete
        descriptionTextField.text = item.details
        
        item.photos?.forEach({ (photoData) in
            imageArray.append(UIImage(data: photoData) ?? UIImage())
        })
    }
    
    func dropPinZoomIn(placemark: MKPlacemark, location: String) {
        //        selectedPin = placemark
        
        mapView!.removeAnnotations(mapView!.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = "\(location)"
        
        //        annotation.subtitle = "\(location)"
        mapView?.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView!.setRegion(region, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch segue.identifier {
        case "LocationSearchVC":
            let searchViewController = segue.destination as! LocationSearchTableViewController
            searchViewController.mapView = self.mapView
            searchViewController.mapView = mapView
            searchViewController.handleMapSearchDelegate = self
            
        case "detailUnwind":
            let name = nameLabel.text ?? ""
            let description = descriptionTextView.text ?? ""
            let goalDate: Date?
            if goalSwitch.isOn {
            goalDate = datePicker.date
            } else {
            goalDate = nil
            }
            let completed = completionSwitch.isOn
            var photos: [Data] = []
            let details = descriptionTextField.text ?? ""
            imageArray.forEach { (image) in
                photos.append(image.pngData() ?? Data())
            }
            if let location = mapView.annotations.first {
                
                item = Item( name: name, description: description, location: Location(latitude: String(location.coordinate.latitude), longitude: String(location.coordinate.longitude), location: location.title!!), goalDate: goalDate, isComplete: completed, photos: photos, details: details, imageArray: imageStringArray)
            } else {
                item = Item( name: name, description: description, location: nil, goalDate: goalDate, isComplete: completed, photos: photos, details: details, imageArray: imageStringArray)
            }
        //        bucketLists[indexOfBucketList].items[indexOfItem] = item!
        //        dataController.saveData(lists: bucketLists)
        
        case "imageSegue" :
            guard segue.identifier == "imageSegue" else {return}
            let destination = segue.destination as! ImageViewController
            let newImage = imageArray[globalIndex]
            destination.newImage = newImage
            
            
        default :
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        globalIndex = indexPath.row
        print(globalIndex)
        performSegue(withIdentifier: "imageSegue", sender: nil)
    }
        
    
    @IBAction func editButton(_ sender: Any) {
        if editMode == false {
            editButton.title = ""
            editButton.image = UIImage(systemName: "checkmark")
            nameLabel.isUserInteractionEnabled = true
            descriptionTextView.isUserInteractionEnabled = true
            //            locationLabel.isUserInteractionEnabled = true
            datePicker.isUserInteractionEnabled = true
            descriptionTextField.isUserInteractionEnabled = true
            
            nameLabel.borderStyle = UITextField.BorderStyle.roundedRect
            
            //          descriptionLabel.borderStyle = UITextField.BorderStyle.roundedRect
            descriptionTextView.layer.borderWidth = 1
            descriptionTextField.layer.borderWidth = 1
            
            editMode = true
        }
        else if editMode == true {
            editButton.title = "Edit"
            editButton.image = nil
            nameLabel.isUserInteractionEnabled = false
            descriptionTextView.isUserInteractionEnabled = false
            //            locationLabel.isUserInteractionEnabled = false
            datePicker.isUserInteractionEnabled = false
            descriptionTextField.isUserInteractionEnabled = false
            
            nameLabel.borderStyle = UITextField.BorderStyle.none
            
            //          descriptionLabel.borderStyle = UITextField.BorderStyle.none
            descriptionTextView.layer.borderWidth = 0
            descriptionTextField.layer.borderWidth = 0
            
            editMode = false
        }
    }
    
    @IBAction func switchFlipped(_ sender: Any) {
        datePicker.isHidden.toggle()
        //animation
    }
    
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
    
    @IBAction func setLocationButtonClicked(_ sender: Any) {
        
        
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Current Location", style: .default, handler: { (action) in
            
            
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.requestWhenInUseAuthorization()
            self.locationManager.requestLocation()
            
            if CLLocationManager.locationServicesEnabled() {
                switch CLLocationManager().authorizationStatus {
                case .authorizedWhenInUse:
                    
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    self.mapView.showsUserLocation = true
                    self.activityIndicator.isHidden = false
                
                case .denied:
                    break
                case .notDetermined:
                    self.locationManager.requestWhenInUseAuthorization()
                    self.mapView.showsUserLocation = true
                case .restricted:
                    break
                case .authorizedAlways:
                    break
                default:
                    break
                }
            } else {
                // Alert
            }
            
        }))
        ac.addAction(UIAlertAction(title: "Find a Location", style: .default, handler: { (action) in
            
            self.performSegue(withIdentifier: "LocationSearchVC", sender: nil)
            
            
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    
    @IBAction func addImageButton(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.allowsEditing = true
        pickerController.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }
    
    func deleteimage() {
        imageArray.remove(at: globalIndex)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        imageArray.append(selectedImage)
        dismiss(animated: true, completion: nil)
        let uid = UUID()
        imageStringArray.append("\(uid)")
        saveLoadImage.saveImage(imageName: "\(uid)", image: selectedImage)
        print("image name", selectedImage)
        resizeCollectionView()
        imageCollectionView.reloadData()
        //dataSource.apply()
    }
    
    @IBAction func unwindFromSearch(unwindSegue: UIStoryboardSegue) {
        print("Success")
    }
    
    fileprivate func resizeCollectionView() {
        if imageArray.count == 0 {
            //collapse collection view
            collectionViewHeight.constant = 0
            //            tableView.reloadSections([4], with: .automatic)
        } else {
            if let height = originalHeight {
                collectionViewHeight.constant = height
                //                tableView.reloadSections([4], with: .automatic)
            }
        }
        tableView.reloadData()
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        print("Unwind worked")
        if segue.identifier == "deleteImage" {
            deleteimage()
            resizeCollectionView()
            imageCollectionView.reloadData()
        }
    }
}

extension DetailListTableViewController : CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let span = MKCoordinateSpan(latitudeDelta: 100, longitudeDelta: 100)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: self.mapView.userLocation.coordinate.latitude, longitude: self.mapView.userLocation.coordinate.longitude)) { (placemarks, error) in
            if (error != nil){
                print("error in reverseGeocode")
            }
            let placemark = placemarks! as [CLPlacemark]
            if placemark.count>0{
                let placemark = placemarks![0]
//                print(placemark.locality!)
//                print(placemark.administrativeArea!)
//                print(placemark.country!)
                
                self.mapView.showsUserLocation = false
                self.dropPinZoomIn(placemark: MKPlacemark(placemark: placemark), location: "\(placemark.locality ?? "City"), \(placemark.administrativeArea ?? "State")")
                self.activityIndicator.isHidden = true
            }
//            print(placemarks)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error:: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }
}

