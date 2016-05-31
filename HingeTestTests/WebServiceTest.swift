//
//  WebServiceTest.swift
//  HingeTest
//
//  Created by Saturnino Teixeira on 5/26/16.
//  Copyright © 2016 Green. All rights reserved.
//
import XCTest

class WebServiceTest: XCTestCase {

    var api : HNGImageService?
    
    override func setUp() {
        super.setUp()
        
        api = HNGImageService()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        
        api = nil
    }

    
    func testReturnsURL() {
    
        let urlString = "https://hinge-homework.s3.amazonaws.com/client/services/homework.json"
        let url = NSURL.init(string: urlString)
        
        XCTAssertNotNil(url)
    }
    
    func testGetListOfImagesForDownload() {
    
        let expectation : XCTestExpectation = self.expectationWithDescription("list expectation")
        api?.getListOfImagesForDownload({ (result) in
            
            XCTAssertNotNil(result)
            expectation.fulfill()
        })
        waitForCompletion()
    }
    
    func testImageIsDownloaded() {
    
        let urlString = "http://pop.h-cdn.co/assets/15/31/980x775/gallery-1438368282-golden-toad.jpg"
        let expectation : XCTestExpectation = self.expectationWithDescription("image expectation")
        
        let request = NSMutableURLRequest.init(URL: NSURL.init(string: urlString)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) { (response, data, error) in
            
            XCTAssertNotNil(data)
            expectation.fulfill()
        }
        waitForCompletion()
    }
    
    
    // MARK: Helper:
    func waitForCompletion() {
    
        waitForExpectationsWithTimeout(5) { (error) in
            
            if error != nil {
                 NSLog("error fulfilling expectation: \(error)");
            }
        }
    }
}
