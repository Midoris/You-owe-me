//
//  Borrower+CoreDataProperties.swift
//  You owe me
//
//  Created by тигренок  on 08/08/2016.
//  Copyright © 2016 Midori.s. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Borrower {

    @NSManaged var name: String?
    @NSManaged var borrowings: NSSet?

}
