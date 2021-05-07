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
    var darkImage = UIImage(named: "darkBucket")
    var lightImage = UIImage(named: "bucket3")
    
    //    @IBOutlet weak var imageView: UIButton!
    
    func configure(label: String, percentage: Double, color: UIColor, landScapeWasChanged: Bool) {
        
        //MARK: Explain Fill Percentage
        
        var newPercentage = percentage
        ownerLabel.text = label
        if percentage == 0 {
            if traitCollection.userInterfaceStyle == .light {
                fill.backgroundColor = .white
            } else {
                fill.backgroundColor = .black
            }
            
            newPercentage = 1
        } else {
            fill.backgroundColor = color
        }
        
        //ADJUST FILL HEIGHT BASED ON PERCENTAGE
        
        let newConstraint = self.fillHeight.constraintWithMultiplier(CGFloat(newPercentage))
        self.contentView.removeConstraint(self.fillHeight)
        self.contentView.addConstraint(newConstraint)
        self.contentView.layoutIfNeeded()
        self.fillHeight = newConstraint
        
        
        //why does this work
        
        if landScapeWasChanged == false {
            if traitCollection.userInterfaceStyle == .light {
                imageView.image = lightImage
            } else {
                imageView.image = darkImage
            }
        } else {
            if imageView.image == darkImage {
                imageView.image = lightImage
            } else if imageView.image == lightImage {
                imageView.image = darkImage
            }
        }
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier == 0 ? 0.00001 : multiplier, constant: self.constant)
    }
}

