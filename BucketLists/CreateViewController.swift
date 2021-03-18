//
//  CreateViewController.swift
//  BucketLists
//
//  Created by Jake Olsen on 3/12/21.
//

import UIKit

class CreateViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var bucketListItemImage: UIImageView!
    @IBOutlet weak var colorButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: false)
        guard let name = nameTextField.text else { return }
        guard let color = view.backgroundColor else { return }
      
    }
    
    @IBAction func colorPickerButtonPressed(_ sender: UIButton) {
        print("Picking Color")
        changeColor()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let LandingVC = segue.destination as? InitialViewController else { return }
        guard let color = view.backgroundColor else { return }
        if let name = nameTextField.text {
            let bucketList: BucketList = BucketList(owner: name, items: [], color: color)
            LandingVC.bucketLists.append(bucketList)
            LandingVC.dataSource.apply(LandingVC.updatedSnapshot)
           
        }
       
    }
    
    func changeColor() {
        let picker = UIColorPickerViewController()
        picker.selectedColor = self.view.backgroundColor!
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}

extension CreateViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
    }
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        self.view.backgroundColor = viewController.selectedColor
    }
}
