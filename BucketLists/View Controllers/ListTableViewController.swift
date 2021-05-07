//
//  ListTableViewController.swift
//  BucketLists
//
//  Created by Chris Harding on 3/10/21.
//

import UIKit

class ListTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var segmentedControl: UISegmentedControl!
    @IBOutlet var percentLabel: UILabel!
    var bucketLists : [BucketList] = []
    var indexOfList: Int = Int()
    var list : [Item] = []
    var listCompleted : [Item] = []
    var bothList : [Item] = []
    var color: UIColor = UIColor()
    var dataController = DataController()
    var selectedRow: Int = Int()
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        navigationController?.setNavigationBarHidden(false, animated: false)
        segmentedControl.selectedSegmentIndex = 1
        updatePercentLabel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let pathName = bucketLists[indexOfList].id.uuidString
        if bucketLists[indexOfList].percentCompleted == 1 {
            if dataController.retrieveValue(pathName: pathName)?.first == nil {
                dataController.saveData(data: [false], pathName: pathName)
            }
        }
        //        && dataController.retrieveValue(pathName: pathName)?.first == false
    }
    
    func updatePercentLabel() {
        if bothList.count > 0 {
            percentLabel.text = "\(Int(bucketLists[indexOfList].percentCompleted*100))%"
        } else {
            percentLabel.text = ""
        }
    }
    
    //    override func viewWillDisappear(_ animated: Bool) {
    //
    //    }
    
    //    override func viewDidDisappear(_ animated: Bool) {
    //        let bucketLists = dataController.retrieveData(pathName: DataController.bucketPathName)
    //        bothList = bucketLists[indexOfList].items
    //        tableView.reloadData()
    //        updatePercentLabel()
    //    }
    
    //    override func viewWillAppear(_ animated: Bool) {
    //        let bucketLists = dataController.retrieveData(pathName: DataController.bucketPathName)
    //        bothList = bucketLists[indexOfList].items
    //        tableView.reloadData()
    //        updatePercentLabel()
    //    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var returnValue = 0
        
        listCompleted.removeAll()
        list.removeAll()
        
        for item in bothList {
            if item.isComplete {
                listCompleted.append(item)
            } else {
                list.append(item)
            }
        }
        
        switch(segmentedControl.selectedSegmentIndex)
        {
        case 0:
            returnValue = listCompleted.count
            break
        case 1:
            returnValue = bothList.count
            break
            
        case 2:
            returnValue = list.count
            break
            
        default:
            break
        }
        return returnValue
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch(segmentedControl.selectedSegmentIndex)
            {
            case 0:
                listCompleted.remove(at: indexPath.section)
                bothList = list + listCompleted
                tableView.deleteSections([indexPath.section], with: .automatic)
                break
            case 1:
                bothList.remove(at: indexPath.section)
                let newUncompletedlist = bothList.filter { $0.isComplete == false}
                list = newUncompletedlist
                
                let newCompletedList = bothList.filter { $0.isComplete == true}
                listCompleted = newCompletedList
                tableView.deleteSections([indexPath.section], with: .automatic)
                break
            case 2:
                list.remove(at: indexPath.section)
                bothList = list + listCompleted
                tableView.deleteSections([indexPath.section], with: .automatic)
                break
            default:
                break
            }
            bucketLists[indexOfList].items.remove(at: indexPath.section)
            tableView.reloadData()
            dataController.saveData(data: bucketLists, pathName: DataController.bucketPathName)
            updatePercentLabel()
            
        } else if editingStyle == .insert {
            //might use later
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListTableViewCell
        let rowNumber = indexPath.section + 1
        
        listCompleted.removeAll()
        list.removeAll()
        
        for item in bothList {
            if item.isComplete {
                listCompleted.append(item)
            } else {
                list.append(item)
            }
        }
        
        switch(segmentedControl.selectedSegmentIndex)
        {
        case 0:
            let completedlist = listCompleted[indexPath.section]
            cell.update(with: completedlist, rowNumber: rowNumber, color: color)
            break
        case 1:
            let bothlist = bothList[indexPath.section]
            if bothlist.isComplete {
                cell.update(with: bothlist, rowNumber: rowNumber, color: color)
            } else {
                if traitCollection.userInterfaceStyle == .light {
                    cell.update(with: bothlist, rowNumber: rowNumber, color: .white)
                } else {
                    cell.update(with: bothlist, rowNumber: rowNumber, color: .black)
                }
            }
            break
            
        case 2:
            let newlist = list[indexPath.section]
            if traitCollection.userInterfaceStyle == .light {
                cell.update(with: newlist, rowNumber: rowNumber, color: .white)
            } else {
                cell.update(with: newlist, rowNumber: rowNumber, color: .black)
            }
            break
            
        default:
            break
        }
        
        //cell configuration
        
        cell.showsReorderControl = true
        cell.layer.cornerRadius = 8
        cell.layer.borderWidth = 0.8
        if traitCollection.userInterfaceStyle == .light {
            cell.layer.borderColor = UIColor.black.cgColor
        } else {
            cell.layer.borderColor = UIColor.white.cgColor
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = .clear
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var item = bothList[indexPath.section]
        switch segmentedControl.selectedSegmentIndex {
        case 0 :
            item = listCompleted[indexPath.section]
        case 1:
            item = bothList[indexPath.section]
        case 2:
            item = list[indexPath.section]
        default:
            break
        }
        //        let cell = tableView.cellForRow(at: indexPath) as! ListTableViewCell
        //        let height = cell.stepStackView.frame.height
        //        return 48 + height
//        var height = 48
//
//        if let steps = item.subSteps {
//            for _ in steps {
//                height += 28
//            }
//            return CGFloat(height)
//        } else {
//            return 48
//        }
        
//        if item.numofSteps > 1 {
//            switch(item.numofSteps)
//            {
//            case 0:
//                return 48
//            case 1:
//                return 48
//            case 2:
//                return 120
//            case 3:
//                return 158
//            case 4:
//                return 168
//            case 5:
//                return 188
//            default:
//                return 48
//            }
//        } else {
//            return 48.0;//Choose your custom row height
//        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.section
        
        performSegue(withIdentifier: "detailSegue", sender: nil)
    }
    
    @IBAction func segmentedControlAction(_ sender: Any) {
        tableView.reloadData()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        
        //take a screenshot of the list and share it
        
        let ac = UIAlertController(title: "Sharing Options", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Image", style: .default, handler: { (_) in
            let bounds = UIScreen.main.bounds
            UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0.0)
            self.view.drawHierarchy(in: bounds, afterScreenUpdates: false)
            let img = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let activityViewController = UIActivityViewController(activityItems: [img], applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
            
        }))
        ac.addAction(UIAlertAction(title: "Text", style: .default, handler: { (_) in
            var myList: [String] = ["My bucket list:"]
            
            for (index, item) in self.bothList.enumerated() {
                
                if index == self.bothList.count-1 {
                    myList.append("\(item.name)")
                } else {
                    myList.append("\(item.name),")
                }
            }
            
            let ac = UIActivityViewController(activityItems: myList, applicationActivities: nil)
            
            self.present(ac, animated: true, completion: nil)
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(ac, animated: true, completion: nil)
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        return "My Bucket List"
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //        bucketLists[indexOfList].items = bothList
        //        dataController.saveData(lists: bucketLists)
        
        //        bucketLists[indexOfList].items = bothList
        //        dataController.saveData(data: bucketLists, pathName: DataController.bucketPathName)
        
        if segue.identifier == "detailSegue" {
            
            
            
            if let indexPath = tableView.indexPathForSelectedRow {
                var item: Item = bothList[indexPath.section]

                switch segmentedControl.selectedSegmentIndex {
                case 0 :
//                    item = listCompleted[indexPath.section]
                    for (index, item11) in bothList.enumerated() {
                        if item11.id == listCompleted[indexPath.section].id {
                            item = bothList[index]
                            selectedRow = index
                        }
                    }
                case 1:
                    item = bothList[indexPath.section]
                case 2:
                    
                    for (index, item11) in bothList.enumerated() {
                        if item11.id == list[indexPath.section].id {
                            item = bothList[index]
                            selectedRow = index
                        }
                    }
//                    item = list[indexPath.section]
                default:
                    break
                }
                
//                item = bothList[indexPath.section]
                let detailTableViewController = segue.destination as! DetailListTableViewController
                print(item)
                detailTableViewController.item = item
                detailTableViewController.bucketLists = bucketLists
                detailTableViewController.indexOfBucketList = indexOfList
                detailTableViewController.indexOfItem = selectedRow
                //detailTableViewController.updateItem(item: item)
            }
        } else if segue.identifier == "MapView" {
            let destination = segue.destination as? MapViewController
            destination?.bucketItems = bothList
            destination?.bucketColor = bucketLists[indexOfList].color.uiColor
        } 
    }
    
    @IBAction func unwind(segue: UIStoryboardSegue) {
        if segue.identifier == "detailUnwind" {
            guard segue.identifier == "detailUnwind",
                  let detailViewController = segue.source as?
                    DetailListTableViewController,
                  let detailitem = detailViewController.item else {return}
            
            bothList[selectedRow] = detailitem
            list.removeAll()
            listCompleted.removeAll()
            
            for item in bothList {
                if item.isComplete {
                    listCompleted.append(item)
                } else {
                    list.append(item)
                }
            }
            
            bucketLists[indexOfList].items = bothList
            dataController.saveData(data: bucketLists, pathName: DataController.bucketPathName)
            tableView.reloadData()
            
        } else if segue.identifier == "doneUnwind" {
            guard segue.identifier == "doneUnwind",
                  let sourceViewController = segue.source as?
                    AddItemTableViewController,
                  let item = sourceViewController.item else {return}
            bothList.append(item)
            list.append(item)
            bucketLists[indexOfList].items.append(item)
            dataController.saveData(data: bucketLists, pathName: DataController.bucketPathName)
            tableView.reloadData()
            updatePercentLabel()
            
        }
    }
    
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func newListButton(_ sender: Any) {
        if let selectedRow = tableView.indexPathsForSelectedRows {
            tableView.deselectRow(at: selectedRow[0], animated: false)
        }
        //        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        //        ac.addAction(UIAlertAction(title: "Single Item", style: .default, handler: { (action) in
        //            //single item vc
        //
        //        }))
        //        ac.addAction(UIAlertAction(title: "Multi-Step Item", style: .default, handler: { (action) in
        //            //multiple item vc
        //        }))
        //        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        //        present(ac, animated: true, completion: nil)
        
        self.present(UIStoryboard(name: "AddListTableView", bundle: nil).instantiateViewController(withIdentifier: "AddListTableViewNav") as UIViewController, animated: true, completion: nil)
    }
}
