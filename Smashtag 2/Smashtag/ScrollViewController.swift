//
//  ScrollViewController.swift
//  Smashtag
//
//  Created by Marco Monteiro on 2/19/15.
//

import UIKit

class ScrollViewController: UIViewController, UIScrollViewDelegate {

    
    var mediaItem: MediaItem? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    //Minimum and maximum set the minimum and maximum zoom scales
    @IBOutlet var scrollView: UIScrollView!
    {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.01
            scrollView.maximumZoomScale = 5.0
        }
    }
    
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    private var imageView = UIImageView();
    
    //When teh UIImage is set we load it into the scroll View.
    private var image: UIImage? {
        get{ return imageView.image }
        set{
            imageView.image = newValue
            imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.height*CGFloat(mediaItem!.aspectRatio), height: self.view.frame.size.height)
            scrollView?.contentSize = imageView.frame.size
        }
    }
    
    //Uses an asynchronous dispatch to load an image from a url
    private func fetchImage()
    {
        if let url = mediaItem!.url {
            let qos = QOS_CLASS_USER_INITIATED
            
            dispatch_async(dispatch_get_global_queue(qos, 0)) { () -> Void in
                let imageData = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.mediaItem!.url {
                        if imageData != nil {
                            self.image = UIImage(data: imageData!)
                        } else {
                            self.image = nil
                        }
                    }
                }
            }
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
