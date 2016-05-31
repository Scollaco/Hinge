//
//  CacheTest.swift
//  HingeTest
//
//  Created by Saturnino Teixeira on 5/27/16.
//  Copyright © 2016 Green. All rights reserved.
//

import XCTest
@testable import HingeTest

class CacheTest: XCTestCase {
    
    var cache : HNGCacheClass?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    
        cache = HNGCacheClass()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        cache = nil
    }
   
    func testEncodeImageObject() {
    
        let image = HNGImage.init(urlString: "url", imageName: "name", img: nil)
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver.init(forWritingWithMutableData: data)
        archiver.encodeObject(image, forKey: image.name)
        archiver.finishEncoding()
        
        
    //    data.writeToFile((cachePath()?.stringByAppendingString("/\(image.name)"))!, atomically: true)
    }
    
    func testCachePathDoesNotReturnNil() {
    
        let urls = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
        let cacheDirectoryURL = urls.first
        
        var cacheDirectory : String? = cacheDirectoryURL!.URLByAppendingPathComponent("cachedImages").path
        if !NSFileManager.defaultManager().fileExistsAtPath(cacheDirectory!) {
            
            do {
                
                try NSFileManager.defaultManager().createDirectoryAtPath(cacheDirectory!, withIntermediateDirectories: false, attributes: [:])
                
            } catch {
                
                print("Error creating directory")
                cacheDirectory = nil
            }
        }
        
       XCTAssertNotNil(cacheDirectory)
    
    
    }
 
}
