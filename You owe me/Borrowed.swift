//
//  Borrowed.swift
//  You owe me
//
//  Created by тигренок  on 08/08/2016.
//  Copyright © 2016 Iablonskyi Ievgenii. All rights reserved.
//

import Foundation
import CoreData


class Borrowed: NSManagedObject {

    class func borrowedWithInfo(_ name: String, iBorrowedState: Bool, currency: String, amount: Double, date: Date, inManagedObgectContext context: NSManagedObjectContext) -> Borrowed? {
        // create borrowed.
        if let borrowed = NSEntityDescription.insertNewObject(forEntityName: "Borrowed", into: context) as? Borrowed {
            borrowed.iBorrowed = iBorrowedState as NSNumber?
            borrowed.currency = currency
            borrowed.amount = amount as NSNumber?
            borrowed.date = date
            borrowed.borrower = Borrower.borrowerWithInfo(name, inManagedObgectContext: context, date: date, currency: currency)
            return borrowed
        }
        
        return nil
    }

}

extension Borrowed {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Borrowed> {
        return NSFetchRequest<Borrowed>(entityName: "Borrowed")
    }

    @NSManaged var timeStamp: NSDate?
}

