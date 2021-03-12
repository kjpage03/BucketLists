//
//  ListTableViewController.swift
//  BucketLists
//
//  Created by Chris Harding on 3/10/21.
//

import UIKit

class ListTableViewController: UITableViewController {

    @IBOutlet weak var mySegmentedControl: UISegmentedControl!
    var list : [List] = []
    var listCompleted : [List] = []
    var bothList : [List] = []
    
    let defaultlist = [
        List(name: "Go to Japan", description: "Take a trip to japan and eat sushi", location: "Japan", goalDate: "10/2/22", completed: false),
        List(name: "Go to Germany", description: "Take a trip to Germany", location: "Germany", goalDate: "10/2/26", completed: false)
    ]
    let defaultlistCompleted = [
        List(name: "The the Grand Canyon", description: "Plant a trip to go visit the Gran Canyon someday", location: "Grand Canyon", goalDate: "12/3/22", completed: true),
        List(name: "Finish school", description: "Finish going to school", location: "Grand Canyon", goalDate: "12/3/21", completed: true)
    ]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if list.isEmpty {
            list = defaultlist
            listCompleted = defaultlistCompleted
            bothList = defaultlist + defaultlistCompleted
            print(bothList)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
        let completedlist = listCompleted[indexPath.row]
        let bothlist = bothList[indexPath.row]
        let newlist = list[indexPath.row]
        let rowNumber = indexPath.row + 1
        
        switch(mySegmentedControl.selectedSegmentIndex)
        {
        case 0:
            cell.update(with: completedlist, rowNumber: rowNumber)
            break
        case 1:
            cell.update(with: bothlist, rowNumber: rowNumber)
            break
            
        case 2:
            cell.update(with: newlist, rowNumber: rowNumber)
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

}
