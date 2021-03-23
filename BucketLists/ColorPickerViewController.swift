//
//  ColorPickerViewController.swift
//  BucketLists
//
//  Created by Jake Olsen on 3/11/21.
//

import UIKit

class ColorPickerViewController: UIViewController, UIColorPickerViewControllerDelegate {
    func changeColor() {
        let picker = UIColorPickerViewController()
        picker.selectedColor = self.view.backgroundColor!
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        changeColor()
        
        // Do any additional setup after loading the view.
    }
}

