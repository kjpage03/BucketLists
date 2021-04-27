//
//  AddListTableViewController.swift
//  BucketLists
//
//  Created by Chris Harding on 3/17/21.
//

import UIKit

class AddListTableViewController: UITableViewController, UITextFieldDelegate {

    var item: Item?
    var numberofStepsINT: Int = 1
    var completedStepsArray = [Int: Bool]()

    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var numberOfSteps: UISegmentedControl!
    @IBOutlet var doneLabel: UIBarButtonItem!
    
    @IBOutlet weak var firstStepText: UITextField!
    @IBOutlet weak var secondStepText: UITextField!
    @IBOutlet weak var thirdStepText: UITextField!
    @IBOutlet weak var fourthStepText: UITextField!
    
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
        return 4 + numberofStepsINT
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
        var stepsStringArray = [String]()
        if let newStep1 = firstStepText.text {
            stepsStringArray.append(newStep1)
        }
        if let newStep2 = secondStepText.text {
            stepsStringArray.append(newStep2)
        }
        if let newStep3 = thirdStepText.text {
            stepsStringArray.append(newStep3)
        }
        if let newStep4 = fourthStepText.text {
            stepsStringArray.append(newStep4)
        }

        
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

            break
        }
        
        item = Item(name: name, description: description, location: nil, goalDate: goalDate, isComplete: false, details: "Describe your experience", imageArray: [], numberofSteps: numberofStepsINT, stepsArray: stepsStringArray, stepsCompleted: [1:false, 2:false, 3: false, 4: false])
    }
    
    
    @IBAction func editingChanged(_ sender: Any) {
        if nameLabel.text?.count != 0 {
            doneLabel.isEnabled = true
        } else {
            doneLabel.isEnabled = false
        }
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

            break
        }
        tableView.reloadData()
        print(numberofStepsINT)
    }
    
}
