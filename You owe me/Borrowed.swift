//
//  Borrowed.swift
//  You owe me
//
//  Created by тигренок  on 08/08/2016.
//  Copyright © 2016 Midori.s. All rights reserved.
//

import Foundation
import CoreData


class Borrowed: NSManagedObject {

    class func borrowedWithInfo(name: String, iBorrowed: Bool, currency: String, amount: Double, date: NSDate, inManagedObgectContext context: NSManagedObjectContext) -> Borrowed? {
        // create borrowed
        if let borrowed = NSEntityDescription.insertNewObjectForEntityForName("Borrowed", inManagedObjectContext: context) as? Borrowed {
            borrowed.iBorrowed = iBorrowed
            borrowed.currency = currency
            borrowed.amount = amount
            borrowed.date = date
            borrowed.borrower = Borrower.borrowerWithInfo(name, inManagedObgectContext: context, date: date, currency: currency)
            return borrowed
        }
        
        return nil
    }

}
