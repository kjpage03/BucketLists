//
//  AddListTableViewController.swift
//  BucketLists
//
//  Created by Chris Harding on 3/17/21.
//

import UIKit

class AddItemTableViewController: UITableViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewAccessibilityDelegate {
    
    var item: Item?
    var numberofStepsINT: Int = 1
    var stepNames: [Substep] = []
    
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
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var stackView: UIStackView!
    var stepNumber: Int = 0
    var labels: [UITextField] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        doneLabel.isEnabled = false
        goalSwitch.isOn = false
        datePicker.isHidden = true
        nameLabel.delegate = self
        pickerView.delegate = self
        pickerView.dataSource = self
        
        rightBucket.rotate360Degrees()
        leftBucket.rotate360Degrees()
        
    }
    
    //MARK: Picker View Data Source
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        10
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "None"
        } else {
            return "\(row)"
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        stepNumber = row
        //        tableView.reloadData()
        for subview in stackView.subviews {
            subview.removeFromSuperview()
        }
        
        if stepNumber > 0 {
            for _ in 0...stepNumber-1 {
                let textField = UITextField()
                textField.placeholder = "Step name"
                stackView.addArrangedSubview(textField)
                labels.append(textField)
//                numberofStepsINT += 1
            }
        }
        tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4 + numberofStepsINT
    }
    
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        if section == 4 {
    //            return 1
    //        } else {
    //            return 1
    //        }
    //    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            if indexPath.row != 0 {
                var height = 48
                for _ in 0...stepNumber {
                    height += 40
                }
                return CGFloat(height)
            } else {
                return 100
            }
        } else {
            return 48
        }
        
        
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
        
        if stepNumber > 1 {
            var ltr: String = String()
//            let labels = [firstStepLabel, secondStepLabel, thirdStepLabel, fourthStepLabel]
            let alphabet: String = "abcdefghijklmnopqrstuvwxyz"
            for index in 0...stepNumber-1 {
                let new = alphabet.index(alphabet.startIndex, offsetBy: index)
                ltr = String(alphabet[new])
                stepNames.append(Substep(name: "\(ltr). \(labels[index].text ?? "")", isComplete: false))
            }
        }
        
        item = Item(id: id, name: name, description: description, location: nil, goalDate: goalDate, isComplete: false, details: "Write about your experience!", imageArray: [], numofSteps: numberofStepsINT, subSteps: stepNames)
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
