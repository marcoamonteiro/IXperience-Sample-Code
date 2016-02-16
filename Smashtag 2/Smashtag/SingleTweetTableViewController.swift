//
//  SingleTweetTableViewController.swift
//  Smashtag
//
//  Created by Marco Monteiro
//

import UIKit

class SingleTweetTableViewController: UITableViewController, UITextFieldDelegate
{

    // MARK: - Public API
    
    var headerTitles = [String]()
    
    //Parses a tweet to create the array tweetElement
    var tweet: Tweet? {
        didSet {
            tweetElements.removeAll()
            var i = 0
            if tweet!.media.count > 0 {
                tweetElements.append([TweetMentions]())
                headerTitles.append("Images")
                for mediaItem in tweet!.media {
                    tweetElements[i].append(TweetMentions.Image(mediaItem))
                }
                i++
            }
            if tweet!.hashtags.count > 0 {
                tweetElements.append([TweetMentions]())
                headerTitles.append("Hashtags")
                for hashtags in tweet!.hashtags {
                    tweetElements[i].append(TweetMentions.Hashtag(hashtags.keyword))
                }
                i++
            }
            if tweet!.urls.count > 0 {
                tweetElements.append([TweetMentions]())
                headerTitles.append("Urls")
                for urls in tweet!.urls {
                    tweetElements[i].append(TweetMentions.Url(urls.keyword))
                }
                i++
            }
            if tweet!.userMentions.count > 0 {
                tweetElements.append([TweetMentions]())
                headerTitles.append("Users")
                for userMentions in tweet!.userMentions {
                    tweetElements[i].append(TweetMentions.User(userMentions.keyword))
                }
                i++
            }
            tableView.reloadData()
        }
    }
    
    private var tweetElements = [[TweetMentions]]()
    
    private enum TweetMentions
    {
        case Image(MediaItem)
        case Hashtag(String)
        case Url(String)
        case User(String)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return tweetElements.count
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweetElements[section].count
    }

    //tweetElements is pre organized in tweet: didSet. this method just loads data at an index, and then creates the appropriate cell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let data = tweetElements[indexPath.section][indexPath.row]

            switch data {
            case .Image(let mediaItem):
                
                let imageCell = tableView.dequeueReusableCellWithIdentifier("image", forIndexPath: indexPath) as! SingleTweetImageTableViewCell
                imageCell.mediaItem = mediaItem
                return imageCell
            case .Hashtag(let text):
                let cell = tableView.dequeueReusableCellWithIdentifier("text", forIndexPath: indexPath) as! SingleTweetTableViewCell
                cell.textLabel?.text = text
                return cell
            case .Url(let text):
                let cell = tableView.dequeueReusableCellWithIdentifier("text", forIndexPath: indexPath) as! SingleTweetTableViewCell
                cell.textLabel?.text = text
                return cell
            case .User(let text):
                let cell = tableView.dequeueReusableCellWithIdentifier("text", forIndexPath: indexPath) as! SingleTweetTableViewCell
                cell.textLabel?.text = text
                return cell
            }
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return headerTitles[section]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        //If the user clicked on a hashtag, @, or URL
        if let cell = sender as? SingleTweetTableViewCell {
            if let indexPath = tableView.indexPathForCell(cell) {
                //If the user clicked on a URL
                if headerTitles[indexPath.section]=="Urls" {
                    if let url = NSURL(string: "\(self.tweet!.urls[indexPath.row].keyword)") {
                        UIApplication.sharedApplication().openURL(url)
                    }
                }
            }
            if let destination = segue.destinationViewController as? TweetTableViewController {
                if let indexPath = tableView.indexPathForCell(cell) {
                    destination.searchText = cell.textLabel?.text
                }
            }
        //If the user clicked on an image
        } else if let cell = sender as? SingleTweetImageTableViewCell {
            if let indexPath = tableView.indexPathForCell(cell) {
                if let destination = segue.destinationViewController as? ScrollViewController {
                    destination.mediaItem = self.tweet!.media[indexPath.row]
                }
            }
        }

    }
    
    //If the cell is going to load an image, this method figures out what size the image will scale to, and returns the appropriate value. Otherwise the method returns the automated dimension of the cell
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(headerTitles[indexPath.section]=="Images") {
            let data = tweetElements[indexPath.section][indexPath.row]
            switch data {
            case .Image(let mediaItem):
                let x =  CGFloat(mediaItem.aspectRatio)
                let y = CGFloat(tableView.frame.size.width)
                let z = y / x
                return z
            default:
                break
            }
        }
        return UITableViewAutomaticDimension
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
