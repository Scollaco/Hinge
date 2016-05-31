//
//  HNGImage.swift
//  HingeTest
//
//  Created by Saturnino Teixeira on 5/26/16.
//  Copyright © 2016 Green. All rights reserved.
//

import UIKit
import AlamofireImage

class HNGImage : NSObject, NSCoding {

    var imageUrl = String()
    var name = String()
    var image : UIImage?
    
    init(urlString: String, imageName:String, img : UIImage?) {
        
        imageUrl = urlString
        name = imageName
        image = img
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        let imageName = (aDecoder.decodeObjectForKey("name") as? String)!
        let urlString = (aDecoder.decodeObjectForKey("imageUrl") as? String)!
        let cachedImage =  aDecoder.decodeObjectForKey("image") as? UIImage
        
        self.init(urlString: urlString, imageName: imageName, img: cachedImage)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(self.name, forKey: "name")
        aCoder.encodeObject(self.imageUrl, forKey: "imageUrl")
        aCoder.encodeObject(self.image, forKey: "image")
    }
    
     func loadImage(size: CGSize?, completion: (UIImage?) -> Void) {
        
        if self.image != nil {
        
            // If the size of the image is not specified, return the original image
            if size == nil {
                completion(self.image)
            } else {
                let scaledImage = image?.af_imageAspectScaledToFillSize(size!)
                completion(scaledImage)
            }
            
            
        } else {
            
            let request = NSMutableURLRequest.init(URL: NSURL.init(string: self.imageUrl)!)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
                
                if error == nil {
                    
                    let image = UIImage.init(data: data!)
                    self.image = image
                    
                    HNGCacheClass.encodeImageObject(self)
                    
                    
                    if size == nil {

                        completion(image)
                    } else {
                        let scaledImage = image?.af_imageAspectScaledToFillSize(size!)
                        completion(scaledImage)
                    }
                    
                } else {
                    completion(UIImage.init(named: "placeholder"))
                }
            }
        }
    }
    
    override var description:String {
         return "Image Description:\n" + "image Url: \(imageUrl)\n" + "name: \(name) + image: \(image)"
    }
}
