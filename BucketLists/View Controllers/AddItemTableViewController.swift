//
//  AddListTableViewController.swift
//  BucketLists
//
//  Created by Chris Harding on 3/17/21.
//

import UIKit

class AddItemTableViewController: UITableViewController, UITextFieldDelegate {

    var item: Item?
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var doneLabel: UIBarButtonItem!
    @IBOutlet var goalSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        doneLabel.isEnabled = false
        goalSwitch.isOn = false
        datePicker.isHidden = true
        nameLabel.delegate = self
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
        header.textLabel?.textColor = .black
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard segue.identifier == "doneUnwind" else {return}
        
        let name = nameLabel.text ?? ""
        let description = descriptionLabel.text ?? ""
//        let location = locationLabel.text ?? ""
        let goalDate: Date?
        let id = UUID()
        if goalSwitch.isOn {
        goalDate = datePicker.date
            
                    let content = UNMutableNotificationContent()
                    content.title = "Bucket List Reminder"
                    content.body = "\(name)"
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
        
        item = Item(id: id, name: name, description: description, location: nil, goalDate: goalDate, isComplete: false, details: "Write about your experience!", imageArray: [])
        let destination = segue.destination as! ListTableViewController
        let placeHolderArray: [Bool]? = []
        DataController().saveData(data: placeHolderArray, pathName: destination.bucketLists[destination.indexOfList].id.uuidString)
        
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        if nameLabel.text?.count != 0 {
            doneLabel.isEnabled = true
        } else {
            doneLabel.isEnabled = false
        }
    }
    
}
