//  test
//  ViewController.swift
//  BucketLists
//
//  Created by Kaleb Page on 3/10/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    @IBAction func pushbutton(_ sender: Any) {
        present( UIStoryboard(name: "ListTableView", bundle: nil).instantiateViewController(withIdentifier: "ListTableView") as UIViewController, animated: true, completion: nil)
    }
    

}

