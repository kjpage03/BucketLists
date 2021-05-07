//
//  StepTableViewCell.swift
//  BucketLists
//
//  Created by Kaleb Page on 5/6/21.
//

import UIKit

class StepTableViewCell: UITableViewCell {
    
    @IBOutlet var stepNameTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
