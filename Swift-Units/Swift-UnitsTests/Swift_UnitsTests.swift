//
//  Swift_UnitsTests.swift
//  Swift-UnitsTests
//
//  Created by Daniel Pink on 9/01/2016.
//  Copyright © 2016 Daniel Pink. All rights reserved.
//

import XCTest
@testable import Swift_Units

class Swift_UnitsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let force = Mass(kg: 2) * gravity
        XCTAssertEqualWithAccuracy(force.N, 9.80665 * 2, accuracy: 0.01)
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
