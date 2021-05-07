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
    
    @IBOutlet var stepOne: UILabel!
    @IBOutlet var stepTwo: UILabel!
    @IBOutlet var stepThree: UILabel!
    @IBOutlet var stepFour: UILabel!
    
    @IBOutlet var stepStackView: UIStackView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
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
        
        //Remove all subviews from stack view
        print(stepStackView.subviews.count)
        print(stepStackView.arrangedSubviews.count)
        
        for subview in stepStackView.arrangedSubviews {
            subview.removeFromSuperview()
        }
        
        //add back as many as needed
        
        if let steps = list.subSteps {
            
            if steps.count > 0 {
                for index in 0...steps.count-1 {
                    let newLabel = UILabel()
                    
                    if steps[index].isComplete == true {
                        
                        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: steps[index].name)
                        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                        newLabel.attributedText = attributeString
                    } else {
                        newLabel.text = steps[index].name
                    }
                    
                    stepStackView.addArrangedSubview(newLabel)
                    //stepStackView.frame.size.height += newLabel.frame.height
                }
            }
        }
        
        backgroundColor = color
        
        let newformatter = DateFormatter()
        newformatter.dateStyle = .short
        if let date = list.goalDate {
            let newDate = newformatter.string(from: date)
            goalDateLabel.text = "\(newDate)"
        } else {
            goalDateLabel.text = ""
        }
        
        
        nameLabel.text = "\(rowNumber). \(list.name)"
    }
}
