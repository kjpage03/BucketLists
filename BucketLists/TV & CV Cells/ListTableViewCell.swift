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
    
//    override var frame: CGRect {
//            get {
//                return super.frame
//            }
//            set (newFrame) {
//                var frame = newFrame
//                let newWidth = frame.width * 0.90
//                let space = (frame.width - newWidth) / 2
//                frame.size.width = newWidth
//                frame.origin.x += space
//
//                super.frame = frame
//
//            }
//        }

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