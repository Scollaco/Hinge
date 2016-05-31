//
//  HNGImageService.swift
//  HingeTest
//
//  Created by Saturnino Teixeira on 5/26/16.
//  Copyright © 2016 Green. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import AlamofireImage


class HNGImageService: NSObject {

    private let urlString = "https://hinge-homework.s3.amazonaws.com/client/services/homework.json"
    
    var images = NSMutableArray()
    
    
    /// Returns the initial array of HNGImage objects for download
    func getListOfImagesForDownload(completion: (NSMutableArray?) -> Void) {
        
        let url = NSURL.init(string: urlString)
       
        guard url != nil else {
            completion(nil)
            return
        }
        
        Alamofire.request(.GET, url!).response { (_, _, data, error) in
         
            let str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            let data = str?.dataUsingEncoding(NSUTF8StringEncoding)
            
            if error != nil {

                return
            } else {
                
                let json =  JSON(data : data!).array
                let imageObjects = self.createObjectsFromArray(json)
                completion(imageObjects)
            }
        }
    }
    
    private func createObjectsFromArray(inputArray : [JSON]?) -> NSMutableArray {
        
        let imageObjectsArray = NSMutableArray()
        
        for dictionary in inputArray! {

            let imageObj = HNGImage.init(urlString: dictionary["imageURL"].stringValue, imageName: dictionary["imageName"].stringValue, img : nil)
            
            imageObjectsArray.addObject(imageObj)
        }
        return imageObjectsArray
    }
}
