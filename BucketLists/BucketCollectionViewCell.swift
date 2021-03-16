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
    //    @IBOutlet weak var imageView: UIButton!
    
    func configure(label: String) {
        ownerLabel.text = label
    }
    
}
