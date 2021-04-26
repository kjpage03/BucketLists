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
        switch(list.numberofSteps)
        {
        case 1:
            stepOneLabel.isHidden = true
            stepTwoLabel.isHidden = true
            stepThreeLabel.isHidden = true
            stepFourLabel.isHidden = true
            
            stepOneButton.isHidden = true
            stepTwoLabel.isHidden = true
            stepThreeLabel.isHidden = true
            stepFourLabel.isHidden = true
            break
        case 2:
            stepOneLabel.isHidden = false
            stepTwoLabel.isHidden = true
            stepThreeLabel.isHidden = true
            stepFourLabel.isHidden = true
            stepOneLabel.text = list.stepsArray[0]

            
            stepOneButton.isHidden = false
            stepTwoLabel.isHidden = true
            stepThreeLabel.isHidden = true
            stepFourLabel.isHidden = true
            break
        case 3:
            stepOneLabel.isHidden = false
            stepTwoLabel.isHidden = false
            stepThreeLabel.isHidden = true
            stepFourLabel.isHidden = true
            stepOneLabel.text = list.stepsArray[0]
            stepTwoLabel.text = list.stepsArray[1]

            
            stepOneButton.isHidden = false
            stepTwoLabel.isHidden = false
            stepThreeLabel.isHidden = true
            stepFourLabel.isHidden = true
            break
            
        case 4:
            stepOneLabel.isHidden = false
            stepTwoLabel.isHidden = false
            stepThreeLabel.isHidden = false
            stepFourLabel.isHidden = true
            stepOneLabel.text = list.stepsArray[0]
            stepTwoLabel.text = list.stepsArray[1]
            stepThreeLabel.text = list.stepsArray[2]

            
            stepOneButton.isHidden = false
            stepTwoLabel.isHidden = false
            stepThreeLabel.isHidden = false
            stepFourLabel.isHidden = true
            break
         
        case 5:
            stepOneLabel.isHidden = false
            stepTwoLabel.isHidden = false
            stepThreeLabel.isHidden = false
            stepFourLabel.isHidden = false
            stepOneLabel.text = list.stepsArray[0]
            stepTwoLabel.text = list.stepsArray[1]
            stepThreeLabel.text = list.stepsArray[2]
            stepFourLabel.text = list.stepsArray[3]

            
            stepOneButton.isHidden = false
            stepTwoLabel.isHidden = false
            stepThreeLabel.isHidden = false
            stepFourLabel.isHidden = false
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
}
