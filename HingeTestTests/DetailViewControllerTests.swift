//
//  DetailViewControllerTests.swift
//  HingeTestTests
//
//  Created by Saturnino Teixeira on 5/26/16.
//  Copyright © 2016 Green. All rights reserved.
//

import XCTest
@testable import HingeTest

class DetailViewControllerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDeleteCurrentImage() {
    
        let obj1 = HNGImage.init(urlString: "", imageName: "obj1", img: nil)
        let obj2 = HNGImage.init(urlString: "", imageName: "obj2", img: nil)
        let obj3 = HNGImage.init(urlString: "", imageName: "obj3", img: nil)
        let obj4 = HNGImage.init(urlString: "", imageName: "obj4", img: nil)
    
        let images = NSMutableArray.init(array: [obj1, obj2, obj3, obj4])
        
        let currentIndex : Int = 2
        images.removeObjectAtIndex(currentIndex)
        
        XCTAssertEqual(images[currentIndex] as? HNGImage, obj4)
    }
    
    
    func testMethodThatShowsNextPicture() {
    
        let obj1 = HNGImage.init(urlString: "", imageName: "obj1", img: nil)
        let obj2 = HNGImage.init(urlString: "", imageName: "obj2", img: nil)
        let obj3 = HNGImage.init(urlString: "", imageName: "obj3", img: nil)
    
        let images = NSMutableArray.init(array: [obj1, obj2, obj3])

        
        var currentIndex : Int = 0
        
        if (currentIndex > (images.count - 1)) {
            currentIndex = 0
        }
        
        let image = imageForIndex(currentIndex + 1, array: images)
        XCTAssertEqual(image, obj2)
    }

    // MARK: Helpers
    func arrayImageObjects() -> NSMutableArray {
    
        let obj1 = HNGImage.init(urlString: "", imageName: "obj1", img: nil)
        let obj2 = HNGImage.init(urlString: "", imageName: "obj2", img: nil)
        let obj3 = HNGImage.init(urlString: "", imageName: "obj3", img: nil)
        let obj4 = HNGImage.init(urlString: "", imageName: "obj4", img: nil)
        
        return NSMutableArray.init(array: [obj1, obj2, obj3, obj4])
    }
    
    func imageForIndex(index : Int, array : NSMutableArray) -> HNGImage? {
        
        if index > array.count - 1 {
            return nil
        }
        
        let imageObj = array.objectAtIndex(index) as? HNGImage
        return imageObj!
    }
}
