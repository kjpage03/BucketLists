//
//  CreateViewController.swift
//  BucketLists
//
//  Created by Jake Olsen on 3/12/21.
//

import UIKit

class CreateViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bucketListItemImage: UIImageView!
    @IBOutlet weak var colorButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var fill: UIView!
    
    var prevTransform: CGFloat = .pi
    var bucketList: BucketList?
    var deleteButtonIsHidden: Bool = true
    var indexInArray: Int?
    let dataController = DataController()
    var deleteButtonWasTapped: Bool = false
    var darkImage = UIImage(named: "darkBucket")
    var lightImage = UIImage(named: "bucket3")
    var isDarkMode: Bool = Bool() {
        didSet {
            if isDarkMode {
                bucketListItemImage.image = darkImage
                doneButton.setTitleColor(.white, for: .normal)
            } else {
                bucketListItemImage.image = lightImage
                doneButton.setTitleColor(.black, for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        doneButton.layer.cornerRadius = 4
        nameTextField.delegate = self
        initializeHideKeyboard()
        
        if traitCollection.userInterfaceStyle == .light {
            isDarkMode = false
        } else {
            isDarkMode = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        deleteButton.isHidden = deleteButtonIsHidden
        deleteButtonWasTapped = false
        if let list = bucketList {
            self.nameTextField.text = list.owner
            self.fill.backgroundColor = list.color.uiColor
        }        
    }
    
    @IBAction func colorPickerButtonPressed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3) {
            let rotateTransform = CGAffineTransform(rotationAngle: self.prevTransform)
            self.prevTransform += .pi
            self.colorButton.transform = rotateTransform
        }
        changeColor()
    }
    
    func changeColor() {
        let picker = UIColorPickerViewController()
        picker.selectedColor = self.view.backgroundColor!
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func switchImages() {
        
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        checkForEmptyTextField()
    }
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        displayWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let color = fill.backgroundColor else { return }
        guard let name = nameTextField.text else { return }
        var bucketLists = dataController.retrieveData(pathName: DataController.bucketPathName)
        
        guard let LandingVC = segue.destination as? InitialViewController else { return }
        if !deleteButtonWasTapped {
            
            //Edit the bucket list that was passed in and save it
            if let index = indexInArray {
                var list = bucketLists[index]
                list.color = Color(uiColor: color)
                list.owner = name
                bucketLists[index] = list
                dataController.saveData(data: bucketLists, pathName: DataController.bucketPathName)
            } else {
                let newBucketList: BucketList = BucketList(owner: name, items: [Item(name: "Example Item", description: "", location: nil, goalDate: Date(), isComplete: true, details: "Write about your experience!", imageArray: [], numofSteps: 0)], color: Color(uiColor: color))
                bucketLists.insert(newBucketList, at: 0)
                dataController.saveData(data: bucketLists, pathName: DataController.bucketPathName)
            }
            
            //Create a new bucket list and save it
            
        } else {
            LandingVC.viewHasDisappeared = false
            LandingVC.collectionView.transform = CGAffineTransform.identity
            LandingVC.animatedCell?.ownerLabel.isHidden = false
            LandingVC.segmentedControl.isHidden = false
            LandingVC.newListButton.isHidden = false
        }
    }
}

extension CreateViewController: UIColorPickerViewControllerDelegate {
    
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        //        self.view.backgroundColor = viewController.selectedColor
        self.fill.backgroundColor = viewController.selectedColor
        UIView.animate(withDuration: 0.3) {
            let rotateTransform = CGAffineTransform(rotationAngle: self.prevTransform)
            self.prevTransform += .pi
            self.colorButton.transform = rotateTransform
        }
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        //        self.view.backgroundColor = viewController.selectedColor
        self.fill.backgroundColor = viewController.selectedColor
    }
    
}

extension CreateViewController {
    func initializeHideKeyboard(){
        //Declare a Tap Gesture Recognizer which will trigger our dismissMyKeyboard() function
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissMyKeyboard))
        
        //Add this tap gesture recognizer to the parent view
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissMyKeyboard(){
        view.endEditing(true)
    }
}

extension CreateViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        if let nextField = self.view.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        return false
    }
}

extension CreateViewController {
    func checkForEmptyTextField() {
        if nameTextField.text == "" {
            let ac = UIAlertController(title: "Give it a name!", message: "Your list must have a name in order to be created.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Got it", style: .default, handler: nil))
            present(ac, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "unwindToList", sender: nil)
        }
    }
    
    func displayWarning() {
        let ac = UIAlertController(title: "Are you sure?", message: "Once you delete a list, you can't get it back.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            //don't delete
            var bucketLists = self.dataController.retrieveData(pathName: DataController.bucketPathName)
            bucketLists.remove(at: self.indexInArray!)
            self.dataController.saveData(data: bucketLists, pathName: DataController.bucketPathName)
            self.deleteButtonWasTapped = true
            self.performSegue(withIdentifier: "unwindFromDelete", sender: nil)
        }))
        present(ac, animated: true, completion: nil)
    }
}
