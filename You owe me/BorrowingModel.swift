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
    /// State of borrowings, if iBorrowed is true it means I borrowed money to Someone, if false Someone borrowed me money.
    internal var iBorrowed = false
    
    // MARK: - Methods
    // Get String from date.
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
    
    // Switch state and return message.
    internal func switchedMessageWithName(name: String) -> String {
        // switch state before decide which message we should return.
        switchState()
        return messageWithBorrowingState(iBorrowed, andName: name)
    }
    
    // Return message depending on borrowing state and name.
    internal func messageWithBorrowingState(state: Bool, andName name: String) -> String {
        switch state {
        case true:
            return "I borrowed \(name)"
        case false:
            return "\(name) borrowed me"
        }
    }

    // Calculate amount and return in String with all required transformations.
    func calculatedAmount(ammount: Double, dependingOnTag tag: Int) -> String {
        let resoult = tag == 0 ? ammount / 2 : ammount * 2 // if tag is 0 split it, else : double.
        return SharedFunctions.stringFromDoubleWithTailingZeroAndRounding(resoult)
    }
    
}




