//
//  TextViewHighlightTests.swift
//  TextViewHighlightTests
//
//  Created by JoeJoe on 2016/8/16.
//  Copyright © 2016年 Joe. All rights reserved.
//

import XCTest
import TextViewHighlight

class TextViewHighlightTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testTextViewHighlight() {
        //let expectation = expectationWithDescription("test")
        let textView: UITextView = UITextView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        
        textView.setMutiContentView("This is some %mark<string #ff8942> that %link<contains[https://yahoo.com.tw]> %mark<the> link this more %link<google[https://google.com.tw]> once. This %mark<substring> has multiple %mark<cases.> ThisthisThIs.")
    }
    
}
