//
//  DetailListTableViewController.swift
//  BucketLists
//
//  Created by Chris Harding on 3/19/21.
//

import UIKit

class DetailListTableViewController: UITableViewController {

   
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var locationLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var completionSwitch: UISwitch!
    
    var item: Item?
    var editMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func updateItem(item: Item) {
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        locationLabel.text = item.location
        datePicker.date = item.goalDate
        completionSwitch.isOn = item.isComplete
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        guard segue.identifier == "detailUnwind" else {return}
        let name = nameLabel.text ?? ""
        let description = descriptionLabel.text ?? ""
        let location = locationLabel.text ?? ""
        let goalDate = datePicker.date
        let completed = completionSwitch.isOn
        item = Item(name: name, description: description, location: location, goalDate: goalDate, isComplete: completed)
    }
    @IBAction func editButton(_ sender: Any) {
        if editMode == false {
            nameLabel.isUserInteractionEnabled = true
            descriptionLabel.isUserInteractionEnabled = true
            locationLabel.isUserInteractionEnabled = true
            datePicker.isUserInteractionEnabled = true
            
            nameLabel.borderStyle = UITextField.BorderStyle.roundedRect
            descriptionLabel.borderStyle = UITextField.BorderStyle.roundedRect
            locationLabel.borderStyle = UITextField.BorderStyle.roundedRect

            editMode = true
        }
        else if editMode == true {
            nameLabel.isUserInteractionEnabled = false
            descriptionLabel.isUserInteractionEnabled = false
            locationLabel.isUserInteractionEnabled = false
            datePicker.isUserInteractionEnabled = false
            
            nameLabel.borderStyle = UITextField.BorderStyle.none
            descriptionLabel.borderStyle = UITextField.BorderStyle.none
            locationLabel.borderStyle = UITextField.BorderStyle.none
            
            editMode = false
        }
    }
    
     @IBAction func CompletionSwitch(_ sender: Any) {
        
     }

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
