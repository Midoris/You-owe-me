//
//  Borrower.swift
//  You owe me
//
//  Created by тигренок  on 08/08/2016.
//  Copyright © 2016 Midori.s. All rights reserved.
//

import Foundation
import CoreData


class Borrower: NSManagedObject {

    class func borrowerWithInfo(name: String, inManagedObgectContext context: NSManagedObjectContext, date: NSDate) -> Borrower? {
        let request = NSFetchRequest(entityName: "Borrower")
        request.predicate = NSPredicate(format: "name = %@", name)
        if let borrower = (try? context.executeFetchRequest(request))?.first as? Borrower {
            // return existing borrower
            borrower.modified = date
            return borrower
        } else if let borrower = NSEntityDescription.insertNewObjectForEntityForName("Borrower", inManagedObjectContext: context) as? Borrower {
            // create new borrower
            borrower.modified = date
            borrower.name = name
            return borrower
        }
        return nil
    }

    
}
