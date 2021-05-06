//
//  AddListTableViewController.swift
//  BucketLists
//
//  Created by Chris Harding on 3/17/21.
//

import UIKit

class AddItemTableViewController: UITableViewController, UITextFieldDelegate {
    
    var item: Item?
    var numberofStepsINT: Int = 1
    var stepNames: [String] = []
    var stepsCompleted: [Bool] = []
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var doneLabel: UIBarButtonItem!
    @IBOutlet var goalSwitch: UISwitch!
    @IBOutlet var rightBucket: UIImageView!
    @IBOutlet var leftBucket: UIImageView!
    @IBOutlet weak var numberOfSteps: UISegmentedControl!
    
    @IBOutlet weak var firstStepLabel: UITextField!
    @IBOutlet weak var secondStepLabel: UITextField!
    @IBOutlet weak var thirdStepLabel: UITextField!
    @IBOutlet weak var fourthStepLabel: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        doneLabel.isEnabled = false
        goalSwitch.isOn = false
        datePicker.isHidden = true
        nameLabel.delegate = self
        
        rightBucket.rotate360Degrees()
        leftBucket.rotate360Degrees()
    }
    
    //    func startRotating() {
    //        UIView.animate(withDuration: 1, delay: 0) {
    //            self.rightBucket.transform = self.rightBucket.transform.rotated(by: .pi)
    //        } completion: { (_) in
    //            UIView.animate(withDuration: 1) {
    //                self.rightBucket.transform = self.rightBucket.transform.rotated(by: .pi * 2)
    //            }
    //            self.startRotating()
    //        }
    //    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4 + numberofStepsINT
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0; //Choose your custom row height
    }
    
    @IBAction func switchFlipped(_ sender: Any) {
        datePicker.isHidden.toggle()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 26
        let currentString: NSString = (textField.text ?? "") as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = .clear
        let header = view as! UITableViewHeaderFooterView
        if traitCollection.userInterfaceStyle == .light {
            header.textLabel?.textColor = .black
        } else {
            header.textLabel?.textColor = .white
        }
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "doneUnwind" else {return}
        ItemName.listItemName = nameLabel.text ?? ItemName.listItemName
        let name = nameLabel.text ?? ""
        let description = descriptionLabel.text ?? ""
        //        let location = locationLabel.text ?? ""
        let goalDate: Date?
        let id = UUID()
        if goalSwitch.isOn {
            goalDate = datePicker.date
            
            let content = UNMutableNotificationContent()
            content.title = "Bucket List Reminder"
            content.body = "\(ItemName.listItemName)"
            content.sound = UNNotificationSound.default
            content.categoryIdentifier = "Actions"
            
            let triggerDateComponents =
                Calendar.current.dateComponents([.minute,
                                                 .hour, .day, .month, .year], from: goalDate!)
            let trigger = UNCalendarNotificationTrigger(dateMatching:
                                                            triggerDateComponents, repeats: false)
            
            let request = UNNotificationRequest(identifier:
                                                    id.uuidString, content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request)
        } else {
            
            goalDate = nil
            
        }
        stepNames.append(firstStepLabel.text ?? "")
        stepNames.append(secondStepLabel.text ?? "")
        stepNames.append(thirdStepLabel.text ?? "")
        stepNames.append(fourthStepLabel.text ?? "")
        
        stepsCompleted.append(false)
        stepsCompleted.append(false)
        stepsCompleted.append(false)
        stepsCompleted.append(false)


        item = Item(id: id, name: name, description: description, location: nil, goalDate: goalDate, isComplete: false, details: "Write about your experience!", imageArray: [], numofSteps: numberofStepsINT, stepnames: stepNames, stepsCompleted: stepsCompleted)
        let destination = segue.destination as! ListTableViewController
        let placeHolderArray: [Bool]? = []
        DataController().saveData(data: placeHolderArray, pathName: destination.bucketLists[destination.indexOfList].id.uuidString)
        
    }
    @IBAction func NumofStepsSegControl(_ sender: Any) {
        switch(numberOfSteps.selectedSegmentIndex)
                {
                case 0:
                    numberofStepsINT = 1
                    break
                case 1:
                    numberofStepsINT = 2
                    break
                case 2:
                    numberofStepsINT = 3
                    break
                case 3:
                    numberofStepsINT = 4
                    break
                case 4:
                    numberofStepsINT = 5
                    break
                default:
                    numberofStepsINT = 1
                    break
                }
                tableView.reloadData()
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        if nameLabel.text?.count != 0 {
            doneLabel.isEnabled = true
        } else {
            doneLabel.isEnabled = false
        }
    }
    
}

extension UIImageView {
    func rotate360Degrees(duration: CFTimeInterval = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
    
    func counterRotate360Degrees(duration: CFTimeInterval = 3) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(-Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
