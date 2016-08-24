//
//  BorrowingVCTests.swift
//  You owe me
//
//  Created by тигренок  on 23/08/2016.
//  Copyright © 2016 Iablonskyi Ievgenii. All rights reserved.
//

import XCTest
@testable import You_owe_me

class SharedFunctionsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testStringFromDoubleWithTailingZeroAndRounding() {
        // The method should round number, remove tail zero and return it in String.
        let expectedResoult = "14.5"
        let resoult = SharedFunctions.stringFromDoubleWithTailingZeroAndRounding(14.530)
        XCTAssertTrue(expectedResoult == resoult, "Returned String is wrong")
    }
    
}
