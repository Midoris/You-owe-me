//
//  Borrower+CoreDataProperties.swift
//  You owe me
//
//  Created by тигренок  on 20/08/2016.
//  Copyright © 2016 Iablonskyi Ievgenii. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Borrower {

    @NSManaged var name: String?
    @NSManaged var modified: NSDate?
    @NSManaged var currency: String?
    @NSManaged var borrowings: NSSet?

}
