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
    @IBOutlet weak var completionCell: CompletionTableViewCell!
    @IBOutlet weak var completionSwitch: UISwitch!
    @IBOutlet var doneLabel: UIBarButtonItem!
    var bucketLists: [BucketList] = []
    var indexOfBucketList: Int = 0
    var indexOfItem: Int = 0
    var dataController = DataController()
    var item: Item?
    var editMode: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.allowsSelection = false
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        updateItem(item: item)
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
//        bucketLists[indexOfBucketList].items[indexOfItem] = item!
//        dataController.saveData(lists: bucketLists)
        
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
    
}
