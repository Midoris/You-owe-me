//
//  BorrowingVC Extension + TableView.swift
//  You owe me
//
//  Created by тигренок  on 02/08/2016.
//  Copyright © 2016 Midori.s. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension BorrowingViewController {
    

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(BorrowingVCConstants.BorrowingHistoryCellID, forIndexPath: indexPath)
        if let borrowed = fetchedResultsController?.objectAtIndexPath(indexPath) as? Borrowed {
            var message: String?
            borrowed.managedObjectContext?.performBlockAndWait {
                message = "I borrowed \(borrowed.borrower?.name) \(borrowed.amount)"
            }
            cell.textLabel?.text = message
        }
        return cell
    }
    
    // DELETE
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if let borrowed = fetchedResultsController?.objectAtIndexPath(indexPath) as? Borrowed {
                borrowed.managedObjectContext?.performBlockAndWait {
                    borrowed.managedObjectContext?.deleteObject(borrowed)
                    do {
                        try self.managedObjectCOntext!.save()
                    } catch let error {
                        print("Core Data Error: \(error)")
                        // TODO: Notify User
                    }
                }
            }
        }
    }

    
     
    
    
    
}
