//
//  ViewController.swift
//  HingeTest
//
//  Created by Saturnino Teixeira on 5/26/16.
//  Copyright © 2016 Green. All rights reserved.
//

import UIKit
import SwiftLoader

let IMAGE_NOTIFICATION = "IMAGE_NOTIFICATION"

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, HNGOfflineViewDelegate {

    var arrayImages = NSMutableArray()
    let cache = NSCache()
    var selectedImage : HNGImage?
    let detailSegue = "detailSegue"
    var offlineView : HNGOfflineView?
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "LARGE PHOTO APP"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(ViewController.didDeleteImage), name: IMAGE_NOTIFICATION, object: nil)

       
        setupNoDataView()
        setupActivityIndicator()
        getImages()
    }
    
    func setupNoDataView(){
    
        offlineView = HNGOfflineView.init(frame: UIScreen.mainScreen().bounds)
        offlineView?.delegate = self
        offlineView?.hidden = true
        view.addSubview(offlineView!)
    
    }
    
    func setupActivityIndicator() {
    
        var config : SwiftLoader.Config = SwiftLoader.Config()
        config.size = 150
        config.spinnerColor = .blackColor()
        config.foregroundColor = .blackColor()
        config.foregroundAlpha = 0.8
        SwiftLoader.setConfig(config)
    }
    
    func getImages() {
    
        if Reachability.isConnectedToNetwork() {
            HNGImageService().getListOfImagesForDownload({ (images) in
                self.arrayImages = images!
                self.collectionView.reloadData()
                self.showNoDataViewIfNeeded()
                
            })
        } else {
        
            self.arrayImages = HNGCacheClass.retrieveCachedImages()!
            self.collectionView.reloadData()
            self.showNoDataViewIfNeeded()
        }
    }
    
    func showNoDataViewIfNeeded(){
        
        dispatch_async(dispatch_get_main_queue()) {
            
            if self.arrayImages.count <= 0 {
                self.offlineView?.hidden = false
            } else {
                self.offlineView?.hidden = true
            }
            
            SwiftLoader.hide()
        }
    }
    
    //MARK: CollectionView Data Source
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayImages.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("galleryCell", forIndexPath: indexPath) as? HNGGalleryCollectionViewCell
        
        cell?.imageView.image = UIImage.init(named: "placeholder")
        
        let currImage = self.arrayImages[indexPath.row] as! HNGImage
       
        if let cachedImage = HNGCacheClass.cachedImage(currImage) {
        
            cell?.imageView.image = cachedImage.image
        } else {
        
            cell?.loadImage(currImage, completion: { (image) in
                
                dispatch_async(dispatch_get_main_queue()) {
                    
                    if let customCell = collectionView.cellForItemAtIndexPath(indexPath) as? HNGGalleryCollectionViewCell {
                        
                        customCell.imageView.image = image
                        if let loadedImage = image {
                            currImage.image = loadedImage
                            
                            HNGCacheClass.cacheImage(currImage)
                            
                        }
                    }
                }
            })
        }
        return cell!
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
     
        let width = UIScreen.mainScreen().bounds.width / 2
        return CGSizeMake(width, width)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 0
    }
    
    // MARK: CollectionView delegate
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    
        selectedImage = arrayImages[indexPath.row] as? HNGImage
        performSegueWithIdentifier(detailSegue, sender: self)
    }
    
    // MARK: OfflineView delegate
    func reloadImages() {
        
        SwiftLoader.show(animated: true)
        getImages()
    }
    
    // MARK: Prepare for segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == detailSegue {
            
            let nextVC = segue.destinationViewController as! HNGDetailViewController
            nextVC.images = arrayImages
            nextVC.currentImage = selectedImage
        }
    }
    
    // MARK: Notification Center 
    func didDeleteImage(notification : NSNotification) {
    
        self.arrayImages = notification.userInfo!["array"] as! NSMutableArray
        self.collectionView.reloadData()
        showNoDataViewIfNeeded();
    }
    
    // MARK: Deinit
    deinit {
        print("HNGViewController dealloc")
        NSNotificationCenter.defaultCenter().removeObserver(self, name: IMAGE_NOTIFICATION, object: nil)
        selectedImage = nil
        offlineView?.delegate = nil
        offlineView?.removeFromSuperview()
        offlineView = nil
    }
}

