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
    //    @IBOutlet weak var imageView: UIButton!
    
    func configure(label: String, percentage: Double, color: UIColor) {
        var newPercentage = percentage
        ownerLabel.text = label
        if percentage == 0 {
            fill.backgroundColor = .white
            newPercentage = 1
        } else {
        fill.backgroundColor = color
        }
//        fill.layer.borderWidth = 1.6
//        fill.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        //ADJUST FILL HEIGHT BASED ON PERCENTAGE
        let newConstraint = fillHeight.constraintWithMultiplier(CGFloat(newPercentage))
        self.contentView.removeConstraint(fillHeight)
        self.contentView.addConstraint(newConstraint)
        self.contentView.layoutIfNeeded()
            fillHeight = newConstraint
        
//        imageView.layer.shadowColor = UIColor.black.cgColor
//        imageView.layer.shadowOpacity = 1
//        imageView.layer.shadowOffset = .zero
//        imageView.layer.shadowRadius = 5
    }
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
         return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier == 0 ? 0.00001 : multiplier, constant: self.constant)
    }
}



//if let imageHeight = imageView.image?.size.height {
//
//    let marginSize = (imageView.frame.height - (imageHeight))
//
//    let actualHeight = imageHeight * CGFloat(percentage)
//
//
//    fill.topAnchor.constraint(equalTo: imageView.topAnchor, constant: marginSize + fill.frame.size.height - fill.frame.size.height*CGFloat(percentage)).isActive = true
//
//    fill.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -marginSize).isActive = true
    
//            fillHeight.constant = actualHeight
    
//            fill.frame.size.height = actualHeight

//}
