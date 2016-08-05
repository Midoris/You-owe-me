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
    private var borrowingState = BorrowingState.Minus
    
    
    // MARK: - Methods
    // Creste new Borrowed Item
    internal func createNewBorrowedItemWithMessage(friendName: String, amount: Double, currency: String) {
        let currentDate = getCurrentDate()
        let borrowedItem = Borrowed(friendName: friendName, borrowingState: borrowingState, currency: currency, ammount: amount, date: currentDate)
        borrowedItems.append(borrowedItem)
        // Post notofication to update UI
        NSNotificationCenter.defaultCenter().postNotificationName("ReloadData", object: nil)
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
    /* When I borrow money to my friend it is a 'Plus' situation
     because my friend should give me this money in the future. 
     And when friend is borrowing money to me it is a 'Minus' situation 
     because in the future I should give this money back to my friend.
    */
    internal enum BorrowingState {
        case Plus
        case Minus
    }

    private func swichState() {
        switch borrowingState {
        case .Plus:
            borrowingState = .Minus
        case .Minus:
            borrowingState = .Plus
        }
    }
    
    internal func switchMessageWithName(name: String) -> String {
        // switch state before decide which message should be shown
        swichState()
        switch borrowingState {
        case .Plus:
            return "I borrowed \(name)"
        case .Minus:
            return "\(name) borrowed me"
        }
    }
    
    internal func getMessageWIthBorrowingState(state: BorrowingModel.BorrowingState, name: String) -> String {
        switch state {
        case .Plus:
            return "I borrowed \(name)"
        case .Minus:
            return "\(name) borrowed me"
        }
    }
    
    
}
