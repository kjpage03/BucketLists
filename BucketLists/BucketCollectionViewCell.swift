//
//  BucketCollectionViewCell.swift
//  BucketLists
//
//  Created by Kaleb Page on 3/11/21.
//

import UIKit

class BucketCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var fill: UIView!
    @IBOutlet weak var fillHeight: NSLayoutConstraint!
    @IBOutlet weak var height: NSLayoutConstraint!
    //    @IBOutlet weak var imageView: UIButton!
    
    func configure(label: String, percentage: Double, color: UIColor) {
        ownerLabel.text = label
        fill.backgroundColor = color
        height.constant = 20
//        fill.heightAnchor.constraint(equalTo: fill.widthAnchor, multiplier: 5.0/7.0).isActive = true
        
//        fill.frame = CGRect(x: fill.frame.origin.x, y: fill.frame.origin.y, width: fill.frame.width, height: 50)
        
//        fillHeight.constant = fillHeight.constant*CGFloat(percentage)
    }
    
}
