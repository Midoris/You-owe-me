//
//  Borrowing Model.swift
//  You owe me
//
//  Created by тигренок  on 02/08/2016.
//  Copyright © 2016 Iablonskyi Ievgenii. All rights reserved.
//

import Foundation

class BorrowingModel {
    
    // MARK: - Variabels
    /// State of borrowings, if iBorrowed is true it means I borrowed money to Someone, if false Someone borrowed me money.
    internal var iBorrowed = false
    
    // MARK: - Methods
    // Get String from date.
    internal func dateStringFromDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    // Switch borrowing state
    fileprivate func switchState() {
        switch iBorrowed {
        case true:
            iBorrowed = false
        case false:
            iBorrowed = true
        }
    }
    
    // Switch state and return message.
    internal func switchedMessageWithName(_ name: String) -> String {
        // switch state before decide which message we should return.
        switchState()
        return messageWithBorrowingState(iBorrowed, andName: name)
    }
    
    // Return message depending on borrowing state and name.
    internal func messageWithBorrowingState(_ state: Bool, andName name: String) -> String {
        switch state {
        case true:
            return "I borrowed \(name)"
        case false:
            return "\(name) borrowed me"
        }
    }

    // Calculate amount and return in String with all required transformations.
    func calculatedAmount(_ ammount: Double, dependingOnTag tag: Int) -> String {
        let resoult = tag == 0 ? ammount / 2 : ammount * 2 // if tag is 0 split it, else : double.
        return SharedFunctions.stringFromDoubleWithTailingZeroAndRounding(resoult)
    }
    
}




