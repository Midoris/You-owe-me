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
        // Put setup code here. This method is called before the invocation of each test method in the class.
        borrowingModel = BorrowingModel()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
    func testGetMessageWithName() {
        let name = "Mark"
        let message = borrowingModel!.switchMessageWithName(name)
        XCTAssertTrue(message == "I borrowed \(name)", "Returned message isn't correct")
    }
    
    func testCreateNewBorrowedItem() {
        let numberOFItemsBeforeNewOneAdded = borrowingModel?.borrowedItems.count
        borrowingModel?.createNewBorrowedItemWithFriend("Mark borrowed me", amount: 56, andCurrency: "$")
        XCTAssertTrue(borrowingModel?.borrowedItems.count > numberOFItemsBeforeNewOneAdded, "New borrowed item wasn't added to borrowedItems")
    }
    
    func testGetMessageWithBorrowingState() {
        let expectedMessage = "Mark borrowed me"
        let result = borrowingModel?.getMessageWithBorrowingState(.Minus, andName: "Mark")
        XCTAssertTrue(expectedMessage == result, "Created message is wrong")
    }
    
    
    
        
}
