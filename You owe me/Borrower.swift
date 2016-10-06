//
//  Borrower.swift
//  You owe me
//
//  Created by тигренок  on 08/08/2016.
//  Copyright © 2016 Iablonskyi Ievgenii. All rights reserved.
//

import Foundation
import CoreData


class Borrower: NSManagedObject {

    class func borrowerWithInfo(_ name: String, inManagedObgectContext context: NSManagedObjectContext, date: Date, currency: String) -> Borrower? {
        //let request = NSFetchRequest(entityName: "Borrower")
        let request: NSFetchRequest<Borrower> = Borrower.fetchRequest()
        request.predicate = NSPredicate(format: "name = %@", name)
        if let borrower = (try? context.fetch(request))?.first as Borrower? {
            // return existing borrower.
            borrower.modified = date
            return borrower
        } else if let borrower = NSEntityDescription.insertNewObject(forEntityName: "Borrower", into: context) as? Borrower {
            // create new borrower.
            borrower.modified = date
            borrower.name = name
            borrower.currency = currency
            return borrower
        }
        return nil
    }

    
}

extension Borrower {
    @nonobjc class func fetchRequest() -> NSFetchRequest<Borrower> {
        return NSFetchRequest<Borrower>(entityName: "Borrower");
    }

    @NSManaged var timeStamp: NSDate?
}

