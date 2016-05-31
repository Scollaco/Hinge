//
//  HNGGalleryCollectionViewCell.swift
//  HingeTest
//
//  Created by Saturnino Teixeira on 5/26/16.
//  Copyright © 2016 Green. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class HNGGalleryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    
    func loadImage(imageObj : HNGImage, completion:(UIImage?) -> Void) {
        
        let thumbnailSize = imageView.frame.size
        imageObj.loadImage(thumbnailSize, completion:{(image) in
            
            
            dispatch_async(dispatch_get_main_queue(), {
                self.activityIndicator.hidden = true
            })
            
            completion(image)
        })
    }
}
