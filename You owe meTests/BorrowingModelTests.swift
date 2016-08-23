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
        /* 
        BorrowingModel have var iBorrowed that is plays a role of State of borrowings, if iBorrowed is true it means I borrowed money to Someone, if false Someone borrowed me money. Initially iBorrowed is false. Each time you call switchedMessageWithName method, it should change iBorrowed to change state of who is borrowing money to whom.
         */
        // First call
        let name = "Mark"
        let firstExpectedMessage = "I borrowed Mark"
        let message = borrowingModel!.switchedMessageWithName(name)
        XCTAssertTrue(message == firstExpectedMessage, "Returned message isn't correct")
        // Second call
        let secondExpectedMessage = "Mark borrowed me"
        let message2 = borrowingModel!.switchedMessageWithName(name)
        XCTAssertTrue(message2 == secondExpectedMessage, "Returned message isn't correct")

    }

    func testMessageWithBorrowingState() {
        // cCse 1: If state is false it means Someone borrowed me money
        let expectedMessage = "Mark borrowed me"
        let result = borrowingModel?.messageWithBorrowingState(false, andName: "Mark")
        XCTAssertTrue(expectedMessage == result, "Created message is wrong")
        // Case 2: If state is true it means I borrowed money to Someone
        let expectedMessage2 = "I borrowed John"
        let result2 = borrowingModel?.messageWithBorrowingState(true, andName: "John")
        XCTAssertTrue(expectedMessage2 == result2, "Created message is wrong")
    }

    func testCalculatedAmount() {
        // Case 1 : If Tag is 0 The method should divide number and return it in a String
        let number1 = 145.0
        let expectedString1 = "72.5"
        let result1 = borrowingModel?.calculatedAmount(number1, dependingOnTag: 0)
        XCTAssertTrue(expectedString1 == result1, "Returned String is wrong")
        // Case 2: If Tag is 1 The method should multiply number and return it in a String
        let number2 = 36.0
        let expectedString2 = "72"
        let result2 = borrowingModel?.calculatedAmount(number2, dependingOnTag: 1)
        XCTAssertTrue(expectedString2 == result2, "Returned String is wrong")
    }
    
        
}
