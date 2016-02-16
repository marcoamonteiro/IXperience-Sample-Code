//
//  HistoryTableViewController.swift
//  Smashtag
//
//  Created by Marco Monteiro on 2/19/15.
//

import UIKit

class HistoryTableViewController: UITableViewController {
    
    var localTweetHistory = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //View Will Appear uses NSUserDefaults to load the search history into localTweetHistory, and then calls reload data on the table view
    override func viewWillAppear(animated: Bool) {
        let defaults = NSUserDefaults.standardUserDefaults()
        if let tweetHistory = defaults.arrayForKey("history") {
            localTweetHistory.removeAll()
            for i in tweetHistory {
                if let test = i as? String {
                    localTweetHistory.append(test)
                }
            }
            defaults.setObject(localTweetHistory, forKey: "history")
            
        }
        tableView.reloadData()
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return localTweetHistory.count
    }


    //sets the text label on the ith cell to the ith value in localTweetHistory
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("historyCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = localTweetHistory[indexPath.row]
        return cell
    }
    
    //Prepare for seque sets the destination search text on the destinatinoViewController to the word you clicked on
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if let cell = sender as? UITableViewCell {
            if let destination = segue.destinationViewController as? TweetTableViewController {
                destination.searchText = cell.textLabel?.text
            }
        }
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
