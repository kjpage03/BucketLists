//
//  ListTableViewController.swift
//  BucketLists
//
//  Created by Chris Harding on 3/10/21.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    var bucketLists : [BucketList] = []
    var indexOfList: Int = Int()
    var list : [Item] = []
    var listCompleted : [Item] = []
    var bothList : [Item] = []
    var color: UIColor = UIColor()
    var dataController = DataController()
    var selectedRow: Int = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        mySegmentedControl.selectedSegmentIndex = 1
        updateTotalLabel()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        bucketLists[indexOfList].items = bothList
        dataController.saveData(lists: bucketLists)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            switch(mySegmentedControl.selectedSegmentIndex)
            {
            case 0:
                listCompleted.remove(at: indexPath.row)
                bothList = list + listCompleted
                tableView.deleteRows(at: [indexPath], with: .fade)
                break
            case 1:
                bothList.remove(at: indexPath.row)
                let newUncompletedlist = bothList.filter { $0.isComplete == false}
                list = newUncompletedlist
                
                let newCompletedList = bothList.filter { $0.isComplete == true}
                listCompleted = newCompletedList
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                break
            case 2:
                list.remove(at: indexPath.row)
                bothList = list + listCompleted
                tableView.deleteRows(at: [indexPath], with: .fade)
                break
            default:
                break
            }
            updateTotalLabel()
            bucketLists[indexOfList].items.remove(at: indexPath.row)
            tableView.reloadData()
            dataController.saveData(lists: bucketLists)
        } else if editingStyle == .insert {
            
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var returnValue = 0
        
        switch(mySegmentedControl.selectedSegmentIndex)
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
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! ListTableViewCell
        let rowNumber = indexPath.row + 1
        
        switch(mySegmentedControl.selectedSegmentIndex)
        {
        case 0:
            let completedlist = listCompleted[indexPath.row]
            cell.update(with: completedlist, rowNumber: rowNumber, color: color)
            break
        case 1:
            let bothlist = bothList[indexPath.row]
            if bothlist.isComplete {
                cell.update(with: bothlist, rowNumber: rowNumber, color: color)
            } else {
                cell.update(with: bothlist, rowNumber: rowNumber, color: .white)
            }
            break
            
        case 2:
            let newlist = list[indexPath.row]
            cell.update(with: newlist, rowNumber: rowNumber, color: .white)
            break
            
        default:
            break
        }
        cell.showsReorderControl = true
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 48.0;//Choose your custom row height
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        
        performSegue(withIdentifier: "detailSegue", sender: nil)
        //present( UIStoryboard(name: "DetailListTableView", bundle: nil).instantiateViewController(withIdentifier: "detailListTableViewNav") as UIViewController, animated: true, completion: nil)
    }
    @IBAction func segmentedControlAction(_ sender: Any) {
        tableView.reloadData()
    }
    
    
    func updateTotalLabel() {
        totalLabel.text = "  \(listCompleted.count)/\(bothList.count)"
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        bucketLists[indexOfList].items = bothList
//        dataController.saveData(lists: bucketLists)
        
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                let item = bothList[indexPath.row]
                let detailTableViewController = segue.destination as! DetailListTableViewController
                print(item)
                detailTableViewController.item = item
                detailTableViewController.bucketLists = bucketLists
                detailTableViewController.indexOfBucketList = indexOfList
                detailTableViewController.indexOfItem = selectedRow
                //detailTableViewController.updateItem(item: item)
            }
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
            
            tableView.reloadData()
            
        }
        else if segue.identifier == "doneUnwind" {
        guard segue.identifier == "doneUnwind",
              let sourceViewController = segue.source as?
                AddListTableViewController,
              let item = sourceViewController.item else {return}
            bothList.append(item)
            list.append(item)
            bucketLists[indexOfList].items.append(item)
            dataController.saveData(lists: bucketLists)
            
            //update table view with new data
            
            tableView.reloadData()
            updateTotalLabel()
        }
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func newListButton(_ sender: Any) {
        if let selectedRow = tableView.indexPathsForSelectedRows {
            tableView.deselectRow(at: selectedRow[0], animated: false)
        }
        let ac = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Single Item", style: .default, handler: { (action) in
            //single item vc
            self.present(UIStoryboard(name: "AddListTableView", bundle: nil).instantiateViewController(withIdentifier: "AddListTableViewNav") as UIViewController, animated: true, completion: nil)
        }))
        ac.addAction(UIAlertAction(title: "Multi-Step Item", style: .default, handler: { (action) in
            //multiple item vc
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(ac, animated: true, completion: nil)
        
    }
}
