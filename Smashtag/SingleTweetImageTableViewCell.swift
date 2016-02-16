//
//  SingleTweetImageTableViewCell.swift
//  Smashtag
//
//  Created by Marco Monteiro on 2/18/15.
//

import UIKit

class SingleTweetImageTableViewCell: UITableViewCell {
    
    var mediaItem: MediaItem? {
        didSet{
            updateUI()
        }
    }

    @IBOutlet weak var imageDisplay: UIImageView!
    var imageDisplays: UIImageView!
    
    //Uses an asyncrhonous dispatch to load an image into the UIImageView in the cell. Also scales the image
    func updateUI() {
        if let nonOptionalImageURL = mediaItem!.url {
            let qos = QOS_CLASS_USER_INITIATED
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                let imageData = NSData(contentsOfURL: nonOptionalImageURL)
                dispatch_async(dispatch_get_main_queue()) { () -> Void in
                    if imageData != nil {
                        self.imageDisplay!.image = UIImage(data: imageData!)
                        self.imageDisplay!.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width/CGFloat(self.mediaItem!.aspectRatio))
                    } else {
                        self.imageDisplay?.image = nil
                    }
               }
           }
        }
    }
}
