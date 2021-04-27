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
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0;//Choose your custom row height
    }
    
    @IBAction func switchFlipped(_ sender: Any) {
        datePicker.isHidden.toggle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard segue.identifier == "doneUnwind" else {return}
        ItemName.listItemName = nameLabel.text ?? ItemName.listItemName
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
        
        item = Item(id: id, name: ItemName.listItemName, description: description, location: nil, goalDate: goalDate, isComplete: false, details: "Write about your experience!", imageArray: [])
        
    }
    
    @IBAction func editingChanged(_ sender: Any) {
        if nameLabel.text?.count != 0 {
            doneLabel.isEnabled = true
        } else {
            doneLabel.isEnabled = false
        }
    }
    
}
