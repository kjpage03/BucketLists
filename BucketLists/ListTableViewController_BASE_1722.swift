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
    var bucket : [BucketList] = []
    var list : [Item] = []
    var listCompleted : [Item] = []
    var bothList : [Item] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(false, animated: false)
        totalLabel.text = "  \(listCompleted.count)/\(bothList.count)"
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
            cell.update(with: completedlist, rowNumber: rowNumber, color: "green")
            break
        case 1:
            let bothlist = bothList[indexPath.row]
            if bothlist.isComplete {
                cell.update(with: bothlist, rowNumber: rowNumber, color: "green")
            } else {
                cell.update(with: bothlist, rowNumber: rowNumber, color: "white")
            }
            break
            
        case 2:
            let newlist = list[indexPath.row]
            cell.update(with: newlist, rowNumber: rowNumber, color: "white")
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
    @IBAction func segmentedControlAction(_ sender: Any) {
        tableView.reloadData()
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    //present( UIStoryboard(name: "ListTableView", bundle: nil).instantiateViewController(withIdentifier: "ListTableView") as UIViewController, animated: true, completion: nil)
    @IBAction func unwind(segue: UIStoryboardSegue) {
        guard segue.identifier == "doneUnwind",
        let sourceViewController = segue.source as?
        AddListTableViewController,
        let item = sourceViewController.item else {return}
        
        if let selectedIndexPath = tableView.indexPathForSelectedRow
        {
            list[selectedIndexPath.row] = item
            tableView.reloadRows(at: [selectedIndexPath], with: .none)
        } else {
            let newIndexPath = IndexPath(row: list.count, section: 0)
            list.append(item)
            bothList = list + listCompleted
            switch(mySegmentedControl.selectedSegmentIndex)
            {
            case 0:
                
                break
            case 1:
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                break
                
            case 2:
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                break
                
            default:
                break
            }
        }
    }
    @IBAction func backButton(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func newListButton(_ sender: Any) {
        if let selectedRow = tableView.indexPathsForSelectedRows {
            tableView.deselectRow(at: selectedRow[0], animated: false)
        }
        present( UIStoryboard(name: "AddListTableView", bundle: nil).instantiateViewController(withIdentifier: "AddListTableViewNav") as UIViewController, animated: true, completion: nil)
    }
}
