//
//  HNGCacheClass.swift
//  HingeTest
//
//  Created by Saturnino Teixeira on 5/26/16.
//  Copyright © 2016 Green. All rights reserved.
//
import UIKit
import Foundation

class HNGCacheClass : NSObject {
    
    static let sharedInstance = HNGCacheClass()
    
    let cache = NSCache()

    /// Caches the image in memory to avoid download it multiple times
    class func cacheImage(object : HNGImage) {
    
        HNGCacheClass.sharedInstance.cache.setObject(object, forKey: object.name)
    }
    
    /// Retrieves the cached image
    class func cachedImage(object : HNGImage) -> HNGImage? {
    
    return HNGCacheClass.sharedInstance.cache.objectForKey(object.name) as? HNGImage
    }
    
    class func cachePath() -> String? {
        
        let urls = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
        let cacheDirectoryURL = urls.first
        
        let cacheDirectory = cacheDirectoryURL!.URLByAppendingPathComponent("cachedImages").path!
        if !NSFileManager.defaultManager().fileExistsAtPath(cacheDirectory) {
            
            do {
                
                try NSFileManager.defaultManager().createDirectoryAtPath(cacheDirectory, withIntermediateDirectories: false, attributes: [:])
                
            } catch {
                
                print("Error creating directory")
                return nil
            }
        }
        return cacheDirectory
    }
    
    /// Writes image to file to allow offline operations
    class func encodeImageObject(image : HNGImage) {
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)
        dispatch_async(queue) {
            
            let data = NSMutableData()
            let archiver = NSKeyedArchiver.init(forWritingWithMutableData: data)
            archiver.encodeObject(image, forKey: image.name)
            archiver.finishEncoding()
            
            
            data.writeToFile((cachePath()?.stringByAppendingString("/\(image.name)"))!, atomically: true)
        }
    }
    
    /// Retrieves all cached images case the app is opened in  offline mode
    class func retrieveCachedImages() -> NSMutableArray? {
        
        do {
            
            let cachedImageNames = try NSFileManager.defaultManager().contentsOfDirectoryAtPath(cachePath()!)
            
            let arrayImages = NSMutableArray()
            
            for item in cachedImageNames {
                
                
                let data = NSData.init(contentsOfFile:cachePath()!.stringByAppendingString("/\(item)"))
                
                guard data != nil else { break }
                
                
                let unarchiver = NSKeyedUnarchiver.init(forReadingWithData: data!)
                let cachedImage = unarchiver.decodeObjectForKey(item) as? HNGImage
                unarchiver.finishDecoding()
                
                if cachedImage != nil {
                    arrayImages.addObject(cachedImage!)
                }
            }
            
            return arrayImages
            
        } catch {
            
            
            return nil
        }
    }
}
