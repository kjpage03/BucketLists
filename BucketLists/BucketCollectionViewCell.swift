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
    //    @IBOutlet weak var imageView: UIButton!
    
    func configure(label: String, percentage: Double, color: UIColor) {
        ownerLabel.text = label
        fill.backgroundColor = color
        
//        fillHeight.constant = fillHeight.constant*CGFloat(percentage)
    }
    
}
