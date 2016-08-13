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
    
    private func swichState() {
        switch iBorrowed {
        case true:
            iBorrowed = false
        case false:
            iBorrowed = true
        }
    }
    
    internal func switchedMessageWithName(name: String) -> String {
        // switch state before decide which message should be shown
        swichState()
        switch iBorrowed {
        case true:
            return "I borrowed \(name)"
        case false:
            return "\(name) borrowed me"
        }
    }
    
    internal func messageWithBorrowingState(state: Bool, andName name: String) -> String {
        switch state {
        case true:
            return "I borrowed \(name)"
        case false:
            return "\(name) borrowed me"
        }
    }
    
}



