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
    internal var iBorrowed = false
    
    // MARK: - Methods
    // Get Date
    internal func dateStringFromDate(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        formatter.dateStyle = .ShortStyle
        let dateString = formatter.stringFromDate(date)
        return dateString
    }
    
    // Switch borrowing state
    private func switchState() {
        switch iBorrowed {
        case true:
            iBorrowed = false
        case false:
            iBorrowed = true
        }
    }
    
    internal func switchedMessageWithName(name: String) -> String {
        // switch state before decide which message we should return
        switchState()
        return messageWithBorrowingState(iBorrowed, andName: name)
    }
    
    internal func messageWithBorrowingState(state: Bool, andName name: String) -> String {
        switch state {
        case true:
            return "I borrowed \(name)"
        case false:
            return "\(name) borrowed me"
        }
    }
    
    private func countedBalance(borrowings: [Borrowed]) -> Double {
        var balance = 0.0
        for borrowed in borrowings {
            let state = Bool(borrowed.iBorrowed!)
            let amount = Double(borrowed.amount!)
            switch state {
            case true : balance += amount
            case false: balance -= amount
            }
        }
        return balance
    }
    
    internal func balanceMessageWithBorrowerName(name: String, borrowings: [Borrowed], andCurrency currency: String) -> String {
        let balance = countedBalance(borrowings)
        switch balance {
        case let x where x > 0 :
            return "\(name) owe me \(stringFromDoubleWithTailingZeroAndRounding(abs(balance))) \(currency)"
        case let x where x < 0:
            return "I owe \(name) \(stringFromDoubleWithTailingZeroAndRounding(abs(balance))) \(currency)"
        default:
            return "clear balance"
        }
    }
    
    func stringFromDoubleWithTailingZeroAndRounding(number: Double) -> String{
        let roundedNumber = Double(round(10*number)/10)
        return String(format: "%g", roundedNumber)
    }
    
    
}




