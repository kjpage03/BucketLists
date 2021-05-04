//
//  ListTableViewCell.swift
//  BucketLists
//
//  Created by Chris Harding on 3/11/21.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var goalDateLabel: UILabel!
    
    @IBOutlet weak var stepOneLabel: UILabel!
    @IBOutlet weak var stepTwoLabel: UILabel!
    @IBOutlet weak var stepThreeLabel: UILabel!
    @IBOutlet weak var stepFourLabel: UILabel!
    
    @IBOutlet weak var stepOneButton: UIButton!
    @IBOutlet weak var stepTwoButton: UIButton!
    @IBOutlet weak var stepThreeButton: UIButton!
    @IBOutlet weak var stepFourButton: UIButton!
    @IBOutlet weak var steckView: UIStackView!
    
    var itemName: String = ""
    var completedStepsArray = [Int: Bool]()
    var listTableViewController = ListTableViewController()
    var bucketLists : [BucketList] = []
    var dataController = DataController()
    var bothList : [Item] = []
    var indexOfList: Int = Int()

    override var frame: CGRect {
            get {
                return super.frame
            }
            set (newFrame) {
                var frame = newFrame
                let newWidth = frame.width * 0.90 
                let space = (frame.width - newWidth) / 2
                frame.size.width = newWidth
                frame.origin.x += space

                super.frame = frame

            }
        }

    override func awakeFromNib() {
        super.awakeFromNib()
//        contentView.layer.borderColor = UIColor.black.cgColor
//        contentView.layer.borderWidth = 1.0
        completedStepsArray = [1: false, 2: false, 3: false, 4: false]
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func update(with list: Item, rowNumber: Int, color: UIColor) {
        
        //if list.completed == true {
        //backgroundColor = UIColor.green
//        if color == "green" {
//            backgroundColor = UIColor.green
//        } else {
//            backgroundColor = .white
//        }
        itemName = list.name
        switch(list.numberofSteps)
        {
        case 1:
            //stepOneLabel.isHidden = true
            //stepTwoLabel.isHidden = true
            //stepThreeLabel.isHidden = true
            //stepFourLabel.isHidden = true
            
            stepOneButton.isHidden = true
            stepTwoButton.isHidden = true
            stepThreeButton.isHidden = true
            stepFourButton.isHidden = true
            
            steckView.spacing = 0
            break
        case 2:
            //stepOneLabel.isHidden = false
            //stepTwoLabel.isHidden = true
            //stepThreeLabel.isHidden = true
            //stepFourLabel.isHidden = true
            //stepOneLabel.text = list.stepsArray[0]
            
            stepOneButton.isHidden = false
            stepTwoButton.isHidden = true
            stepThreeButton.isHidden = true
            stepFourButton.isHidden = true
            
            steckView.spacing = 0
            break
        case 3:
            //stepOneLabel.isHidden = false
            //stepTwoLabel.isHidden = false
            //stepThreeLabel.isHidden = true
            //stepFourLabel.isHidden = true
            //stepOneLabel.text = list.stepsArray[0]
            //stepTwoLabel.text = list.stepsArray[1]

            
            stepOneButton.isHidden = false
            stepTwoButton.isHidden = false
            stepThreeButton.isHidden = true
            stepFourButton.isHidden = true
            
            steckView.spacing = 10
            break
            
        case 4:
            //stepOneLabel.isHidden = false
            //stepTwoLabel.isHidden = false
            //stepThreeLabel.isHidden = false
            //stepFourLabel.isHidden = true
            //stepOneLabel.text = list.stepsArray[0]
            stepTwoLabel.text = list.stepsArray[1]
            stepThreeLabel.text = list.stepsArray[2]

            
            stepOneButton.isHidden = false
            stepTwoButton.isHidden = false
            stepThreeButton.isHidden = false
            stepFourButton.isHidden = true
            
            steckView.spacing = -5
            break
         
        case 5:
            //stepOneLabel.isHidden = false
            //stepTwoLabel.isHidden = false
            //stepThreeLabel.isHidden = false
            //stepFourLabel.isHidden = false
            //stepOneLabel.text = list.stepsArray[0]
            //stepTwoLabel.text = list.stepsArray[1]
            //stepThreeLabel.text = list.stepsArray[2]
            //stepFourLabel.text = list.stepsArray[3]

            
            stepOneButton.isHidden = false
            stepTwoButton.isHidden = false
            stepThreeButton.isHidden = false
            stepFourButton.isHidden = false
            
            steckView.spacing = -15
            break
            
        default:
            break
        }
        backgroundColor = color
        
        let newformatter = DateFormatter()
        newformatter.dateStyle = .short
        let newDate = newformatter.string(from: list.goalDate)
        goalDateLabel.text = "\(newDate)"
        
        nameLabel.text = "\(rowNumber). \(list.name)"
    }
    @IBAction func stepOneButton(_ sender: Any) {
        if stepOneButton.isSelected == false {
            stepOneButton.isSelected = true
            completedStepsArray.updateValue(true, forKey: 1)
            //saveSteps(name: itemName, array: ["\(completedStepsArray)"])
        }else if stepOneButton.isSelected == true{
            stepOneButton.isSelected = false
            completedStepsArray.updateValue(false, forKey: 1)
        }
    }
    @IBAction func stepTwoButton(_ sender: Any) {
        if stepTwoButton.isSelected == false {
            stepTwoButton.isSelected = true
            completedStepsArray.updateValue(true, forKey: 2)
        }else if stepTwoButton.isSelected == true{
            stepTwoButton.isSelected = false
            completedStepsArray.updateValue(false, forKey: 2)
        }
    }
    @IBAction func stepThreeButton(_ sender: Any) {
        
        if stepFourButton.isSelected == false {
            stepFourButton.isSelected = true
            completedStepsArray.updateValue(true, forKey: 4)
        }else if stepFourButton.isSelected == true{
            stepFourButton.isSelected = false
            completedStepsArray.updateValue(false, forKey: 4)

        }
    }
    @IBAction func stepFourButton(_ sender: Any) {
        if stepThreeButton.isSelected == false {
            stepThreeButton.isSelected = true
            completedStepsArray.updateValue(true, forKey: 3)
        }else if stepThreeButton.isSelected == true{
            stepThreeButton.isSelected = false
            completedStepsArray.updateValue(false, forKey: 3)
        }
    }
    func saveSteps(name: String, array: [String]) {
        bucketLists = dataController.retrieveData(pathName: DataController.bucketPathName)
        for item in bucketLists{
            bothList.append(contentsOf: item.items)
        }
        
        let filteredList = bothList.filter { $0.name == name}
        let bucketIndex = bucketLists.firstIndex(where: { $0.owner == name})
        print("bucket index \(bucketIndex)")
        if let index = bothList.firstIndex(where: { $0.name == name }) {
            print(filteredList)
            var filteredresults = filteredList[0]
            filteredresults.stepsArray = array
            bothList[index] = filteredresults
            //print(array)
            //bucketLists[indexOfList].items = bothList
            //dataController.saveData(data: bucketLists, pathName: DataController.bucketPathName)
        }
            //
    }
    func deleteSteps() {
        
    }
}
