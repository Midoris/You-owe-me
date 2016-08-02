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
    
    
    // MARK: - Methods
    // Creste new Borrowed Item
    internal func createNewBorrowedItemWithMessage(message: String, amount: Double) {
        let currentDate = getCurrentDate()
        borrowedItems.append(Borrowed(borrowingMessage: message, ammount: amount, date: currentDate))
        // Post notofication to update UI
        NSNotificationCenter.defaultCenter().postNotificationName("UpdateUI", object: nil)
    }
    
    // Get Date
    private func getCurrentDate() -> String {
        let date = NSDate()
//        let calendar = NSCalendar.currentCalendar()
//        let requestedComponents: NSCalendarUnit = [
//            .Year,
//            .Month,
//            .Day,
//            .Hour,
//            .Minute
//        ]
//        _ = calendar.components(requestedComponents, fromDate: date)
//        
        return toShortTimeString(date)
    }
    
    private func toShortTimeString(date: NSDate) -> String {
        let formatter = NSDateFormatter()
        formatter.timeStyle = .ShortStyle
        formatter.dateStyle = .ShortStyle
        let timeString = formatter.stringFromDate(date)
        
        return timeString
    }
    
}
