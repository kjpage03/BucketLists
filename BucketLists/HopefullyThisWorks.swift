//
//  HopefullyThisWorks.swift
//  BucketLists
//
//  Created by Kaleb Page on 3/12/21.
//

import Foundation
import UIKit

final class OrtogonalScrollingCollectionView: UICollectionView {

    override var delegate: UICollectionViewDelegate? {
        get { super.delegate }
        set {
            super.delegate = newValue
            subviews.forEach { (view) in
//                guard String(describing: type(of: view)) == "_UICollectionViewOrthogonalScrollerEmbeddedScrollView" else { return }
                guard let scrollView = view as? UIScrollView else { return }
                scrollView.delegate = newValue
            }
        }
    }
}

