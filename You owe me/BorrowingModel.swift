//
//  Borrowing Model.swift
//  You owe me
//
//  Created by тигренок  on 02/08/2016.
//  Copyright © 2016 Midori.s. All rights reserved.
//

import Foundation
import CoreData


class BorrowingModel {
    
    // MARK: - Variabels
    internal var borrowedItems = [BorrowedStr]()
    private var borrowingState = BorrowingState.Minus
    
    
    
    
    // MARK: - Methods
    // Creste new Borrowed Item
    internal func createNewBorrowedItemWithFriend(friendName: String, amount: Double, andCurrency currency: String) {
        let currentDate = getCurrentDate()
        let borrowedItem = BorrowedStr(friendName: friendName, borrowingState: borrowingState, currency: currency, ammount: amount, date: currentDate)
        borrowedItems.append(borrowedItem)
        // Post notofication to update UI
        NSNotificationCenter.defaultCenter().postNotificationName(BorrowingVCConstants.UpdateUI, object: nil)
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
    
    internal func getMessageWithBorrowingState(state: BorrowingState, andName name: String) -> String {
        switch state {
        case .Plus:
            return "I borrowed \(name)"
        case .Minus:
            return "\(name) borrowed me"
        }
    }
    
    internal func getBalanceMessageWithFriend(name: String, andCurrency currency: String) -> String {
        let balance = countBalance()
        switch balance {
        case let x where x > 0 :
            return "\(name) owe me \(abs(balance)) \(currency)"
        case let x where x < 0:
            return "I owe \(name) \(abs(balance)) \(currency)"
        default:
            return "clear balance"
        }
    }
    
    private func countBalance() -> Double {
        var balance: Double = 0
        for item in borrowedItems {
            let amount = item.ammount
            let state = item.borrowingState
            switch state {
            case .Plus:
                balance += amount
            case .Minus:
                balance -= amount
            }
        }
        return balance
    }
    
        
    
    
    
}

// Borrowing states
/* When I borrow money to my friend it is a 'Plus' situation
 because my friend should give me this money in the future.
 And when friend is borrowing money to me it is a 'Minus' situation
 because in the future I should give this money back to my friend.
 */
enum BorrowingState {
    case Plus
    case Minus
}





