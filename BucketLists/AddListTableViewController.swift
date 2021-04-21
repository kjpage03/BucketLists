//
//  AddListTableViewController.swift
//  BucketLists
//
//  Created by Chris Harding on 3/17/21.
//

import UIKit

class AddListTableViewController: UITableViewController, UITextFieldDelegate {

    var item: Item?
    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet var doneLabel: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        doneLabel.isEnabled = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0;//Choose your custom row height
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard segue.identifier == "doneUnwind" else {return}
        
        let name = nameLabel.text ?? ""
        let description = descriptionLabel.text ?? ""
//        let location = locationLabel.text ?? ""
        let goalDate = datePicker.date

        item = Item(name: name, description: description, location: nil, goalDate: goalDate, isComplete: false, details: "Write about your experience!", imageArray: [])
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        let content = UNMutableNotificationContent()
        content.title = "You have a goal date today!"
        content.subtitle = "\(name)'s goal date was today."
        content.sound = UNNotificationSound.default
        let alertDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: goalDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: alertDate, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
        
        

    }
    
    
    @IBAction func editingChanged(_ sender: Any) {
        if nameLabel.text?.count != 0 {
            doneLabel.isEnabled = true
        } else {
            doneLabel.isEnabled = false
        }
    }
    
}
