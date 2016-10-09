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
    /// State of borrowings, if iBorrowedState is true it means I borrowed money to Someone, if it is false Someone borrowed me money.
    internal var iBorrowedState = false
    
    // MARK: - Methods
    // Get String from date.
    internal func dateString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .short
        let dateString = formatter.string(from: date)
        return dateString
    }
    
    // Switch borrowing state
    fileprivate func switchState() {
        switch iBorrowedState {
        case true:
            iBorrowedState = false
        case false:
            iBorrowedState = true
        }
    }
    
    // Switch state and return message.
    internal func switchedMessage(with borrowerName: String) -> String {
        // switch state before decide which message we should return.
        switchState()
        return message(with: iBorrowedState, and: borrowerName)
    }
    
    // Return message depending on borrowing state and name.
    internal func message(with borrowingState: Bool, and borrowerName: String) -> String {
        switch borrowingState {
        case true:
            return "I borrowed \(borrowerName)"
        case false:
            return "\(borrowerName) borrowed me"
        }
    }

    // Calculate amount and return in String with all required transformations.
    func calculatedAmount(_ amount: Double, dependingOnTag tag: Int) -> String {
        let resoult = tag == 0 ? amount / 2 : amount * 2 // if tag is 0 split it, else : double.
        return SharedFunctions.stringFromDoubleWithTailingZeroAndRounding(resoult)
    }
    
}




