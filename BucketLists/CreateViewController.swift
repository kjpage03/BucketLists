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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        doneButton.layer.cornerRadius = 4
        
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
    
    
    @IBAction func deleteButtonTapped(_ sender: Any) {
        let ac = UIAlertController(title: "Are you sure?", message: "Once you delete a list, you can't get it back.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
            //don't delete
            var bucketLists = self.dataController.retrieveData()
            bucketLists.remove(at: self.indexInArray!)
            self.dataController.saveData(lists: bucketLists)
            self.deleteButtonWasTapped = true
            self.performSegue(withIdentifier: "unwindFromDelete", sender: nil)
        }))
        present(ac, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let color = fill.backgroundColor else { return }
        guard let name = nameTextField.text else { return }
        var bucketLists = dataController.retrieveData()

        //        guard let LandingVC = segue.destination as? InitialViewController else { return }
        if !deleteButtonWasTapped {
            
            //Edit the bucket list that was passed in and save it
            if let index = indexInArray {
            var list = bucketLists[index]
            list.color = Color(uiColor: color)
            list.owner = name
            bucketLists[index] = list
            dataController.saveData(lists: bucketLists)
            } else {
                let newBucketList: BucketList = BucketList(owner: name, items: [Item(name: "Do something", description: "", location: nil, goalDate: Date(), isComplete: true)], color: Color(uiColor: color))
                //            LandingVC.bucketLists.append(bucketList)
//                var bucketLists = dataController.retrieveData()
                bucketLists.insert(newBucketList, at: 0)
                dataController.saveData(lists: bucketLists)
            }
            //Create a new bucket list and save it
            
                
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
