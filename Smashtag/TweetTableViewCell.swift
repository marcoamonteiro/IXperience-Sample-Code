//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by Marco Monteiro
//

import UIKit

class TweetTableViewCell: UITableViewCell
{
    var tweet: Tweet? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    func updateUI() {
        
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        

        
        
        if let tweet = self.tweet
        {
            tweetTextLabel?.text = tweet.text
            //Highlights different elements of the tweet
            if tweetTextLabel?.text != nil  {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
                let tweetText: NSMutableAttributedString = NSMutableAttributedString(attributedString: tweetTextLabel.attributedText!)
                for hashtags in tweet.hashtags {
                    tweetText.addAttribute(NSBackgroundColorAttributeName, value: UIColor.greenColor(), range: hashtags.nsrange)
                }
                for urls in tweet.urls {
                    tweetText.addAttribute(NSBackgroundColorAttributeName, value: UIColor.yellowColor(), range: urls.nsrange)
                }
                for userMentions in tweet.userMentions {
                    tweetText.addAttribute(NSBackgroundColorAttributeName, value: UIColor.grayColor(), range: userMentions.nsrange)
                }

                tweetTextLabel.attributedText = tweetText
            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)"
            
            //Loads the profile image
            if let profileImageURL = tweet.user.profileImageURL {
                    let qos = QOS_CLASS_USER_INITIATED
                    dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                        let imageData = NSData(contentsOfURL: profileImageURL)
                        dispatch_async(dispatch_get_main_queue()) {
                                if imageData != nil {
                                    self.tweetProfileImageView?.image = UIImage(data: imageData!)
                                } else {
                                    self.tweetProfileImageView?.image = nil
                                }
                            }
                    
                }

            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }

    }
}
