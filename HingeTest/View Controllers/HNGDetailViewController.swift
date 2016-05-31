//
//  HNGDetailViewController.swift
//  HingeTest
//
//  Created by Saturnino Teixeira on 5/26/16.
//  Copyright © 2016 Green. All rights reserved.
//

import UIKit

class HNGDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    var images : NSMutableArray?
    var currentImage : HNGImage?
    var timer : NSTimer?
    var currentIndex : Int? = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
    }
    
    func setupNavigationBar() {

        navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "trash"), style: .Plain, target: self, action: #selector(HNGDetailViewController.deleteCurrentImage))
        
        navigationItem.rightBarButtonItem?.imageInsets = UIEdgeInsetsMake(15, 15, 15, 15)
        navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()

    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)

        timer?.invalidate()
        timer = nil
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        currentIndex = images?.indexOfObject(currentImage!)
        title = titleForIndex(currentIndex!)
        
        currentImage?.loadImage(nil , completion:  { (image) in
            self.imageView.image = image
        })
        startGalleryPresentationTimer()
    }
    
    func imageForIndex(index : Int, completion: (UIImage?) -> Void) {
    
        guard index <= images!.count - 1 else {
            completion(nil)
            return
        }
        
        let imageObj = images!.objectAtIndex(index) as? HNGImage
        imageObj!.loadImage(nil, completion: { (image) in
            completion(image)
        })
    }
    
    func startGalleryPresentationTimer() {
    
        if timer == nil {
        
           timer = NSTimer.scheduledTimerWithTimeInterval(2.6, target: self, selector: #selector(HNGDetailViewController.showNextPicture), userInfo: nil, repeats: true)
        }
    }
    
    func deleteCurrentImage()  {
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.timer?.invalidate()
            self.timer = nil
        }
        
        let alert = UIAlertController.init(title: "Hinge", message: "Delete the image?" , preferredStyle: .Alert)
        let cancelAction = UIAlertAction.init(title: "Cancel", style: .Default, handler: { (action) in
            self.startGalleryPresentationTimer()
        })
        
        
        let deleteAction = UIAlertAction.init(title: "Delete", style: .Default) { (action) in
         
            self.images?.removeObjectAtIndex(self.currentIndex!)
        
            // Updates the array on HNGViewController to delete the thumbnails of the deleted images
            NSNotificationCenter.defaultCenter().postNotificationName(IMAGE_NOTIFICATION, object: nil, userInfo: ["array" : self.images!])
            
            
            if self.images?.count == 0 {
                self.navigationController?.popViewControllerAnimated(true)
                return
            }
            
            // If the removed object was the last in the array, reset the index to 0
            if self.currentIndex >= self.images?.count {
                self.currentIndex = 0
            }
            
            self.imageForIndex(self.currentIndex!, completion: { (image) in
                self.imageView.image = image
                self.title = self.titleForIndex(self.currentIndex!)
            })
            self.startGalleryPresentationTimer()
            
        }
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func showNextPicture() {
    
        currentIndex! += 1
        UIView.animateWithDuration(0.3, animations: { 
            
            self.imageView.alpha = 0
            
            }) { (finished) in
                
                UIView.animateWithDuration(0.3, animations: { 
                    
                    if (self.currentIndex > (self.images!.count - 1)) {
                        self.currentIndex = 0
                    }
                    
                    self.imageForIndex(self.currentIndex!, completion: { (image) in
                        self.imageView.image = image
                        self.imageView.alpha = 1.0
                        self.title = self.titleForIndex(self.currentIndex!)
                    })
            })
        }
    }
    
    // MARK:  Helper
    
    func titleForIndex(index : Int) -> String {
        return "\(index + 1)" + "/" + "\(self.images!.count)"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: Deinit
    deinit {
    
        print("HNGDetailViewController dealloc")
        images = nil
        currentIndex = nil
    }
   
}
