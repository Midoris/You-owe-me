//
//  BorrowingModelTests.swift
//  You owe me
//
//  Created by тигренок  on 04/08/2016.
//  Copyright © 2016 Midori.s. All rights reserved.
//

import XCTest
@testable import You_owe_me

class BorrowingModelTests: XCTestCase {
    
    var borrowingModel: BorrowingModel?
    
    
    override func setUp() {
        super.setUp()
        borrowingModel = BorrowingModel()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testMessageWithName() {
        let name = "Mark"
        let message = borrowingModel!.switchedMessageWithName(name)
        XCTAssertTrue(message == "I borrowed \(name)", "Returned message isn't correct")
    }

    func testMessageWithBorrowingState() {
        // case 1
        let expectedMessage = "Mark borrowed me"
        let result = borrowingModel?.messageWithBorrowingState(false, andName: "Mark")
        XCTAssertTrue(expectedMessage == result, "Created message is wrong")
        // case 2
        let expectedMessage2 = "I borrowed John"
        let result2 = borrowingModel?.messageWithBorrowingState(true, andName: "John")
        XCTAssertTrue(expectedMessage2 == result2, "Created message is wrong")
    }

    func testCalculatedAmount() {
        // case 1
        let expectedString1 = "72.5"
        let result1 = borrowingModel?.calculatedAmount(145, dependingOnTag: 0)
        XCTAssertTrue(expectedString1 == result1, "Returned String is wrong")
        // case 2
        let expectedString2 = "72"
        let result2 = borrowingModel?.calculatedAmount(36, dependingOnTag: 1)
        XCTAssertTrue(expectedString2 == result2, "Returned String is wrong")
    }
    
        
}
