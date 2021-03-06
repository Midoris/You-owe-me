//
//  SheredFunctions.swift
//  You owe me
//
//  Created by тигренок  on 22/08/2016.
//  Copyright © 2016 Iablonskyi Ievgenii. All rights reserved.
//

import Foundation
import UIKit

struct SharedFunctions {
    
    // Show Error Alert
    static func showErrorAlert(in controller: UIViewController) {
        let alertController = UIAlertController(title: nil, message:
            "An error occurred in attempt to save changes, please try again.", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.default,handler: nil))
        controller.present(alertController, animated: true, completion: nil)
    }
    
    // Get calculated balance and return it in message depending on is it negative or positive.
    static func balanceMessage(with borrowerName: String, borrowings: [Borrowed], and currency: String) -> String {
        let balance = SharedFunctions.countedBalance(for: borrowings)
        switch balance {
        case let x where x > 0 :
            return "\(borrowerName) owe me \(SharedFunctions.stringFromDoubleWithTailingZeroAndRounding(abs(balance))) \(currency)"
        case let x where x < 0:
            return "I owe \(borrowerName) \(SharedFunctions.stringFromDoubleWithTailingZeroAndRounding(abs(balance))) \(currency)"
        default:
            return "clear balance"
        }
    }
    
    // Round number, remove tail zero and transform it into String.
    static func stringFromDoubleWithTailingZeroAndRounding(_ number: Double) -> String{
        let roundedNumber = Double(round(10*number)/10)
        return String(format: "%g", roundedNumber)
    }
    
    // Count balanse from borrowings depending on state of each of borrowed items.
    static private func countedBalance(for borrowings: [Borrowed]) -> Double {
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
    
}
