//
//  Borrowing Model.swift
//  You owe me
//
//  Created by тигренок  on 02/08/2016.
//  Copyright © 2016 Midori.s. All rights reserved.
//

import Foundation

class BorrowingModel {
    
    // MARK: - Variabels
    internal var borrowedItems = [Borrowed]()
    private var borrowingState = BorrowingMessageState.Forward
    
    
    // MARK: - Methods
    // Creste new Borrowed Item
    internal func createNewBorrowedItemWithMessage(message: String, amount: Double, currency: String) {
        let currentDate = getCurrentDate()
        let borrowedItem = Borrowed(borrowingMessage: message, currency: currency, ammount: amount, date: currentDate)
        borrowedItems.append(borrowedItem)
        // Post notofication to update UI
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateUI", object: nil)
    }
    
    // Get Date
    private func getCurrentDate() -> String {
        let date = NSDate()
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        formatter.dateStyle = .ShortStyle
        let dateString = formatter.stringFromDate(date)
        
        return dateString
    }
    
    // Borrowing states
    private enum BorrowingMessageState {
        case Forward
        case Backward
    }
    
    private func swichState(state: BorrowingMessageState) -> BorrowingMessageState {
        switch state {
        case .Forward :
            return .Backward
        case .Backward :
            return .Forward
        }
    }
    
    internal func getMessageWithName(name: String) -> String {
        // switch state before exit the func
        defer {
            borrowingState =  swichState(borrowingState)
        }
        switch borrowingState {
        case .Forward:
            return "I borrowed \(name)"
        case .Backward:
            return "\(name) borrowed me"
        }
    }
    
    
}
