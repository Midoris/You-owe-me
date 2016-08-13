//
//  BorrowersVC+TableViewDelegate.swift
//  You owe me
//
//  Created by тигренок  on 12/08/2016.
//  Copyright © 2016 Midori.s. All rights reserved.
//

import Foundation
import UIKit

extension BorrowersViewController {
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("borrowerCell", forIndexPath: indexPath)
        if let borrower = fetchedResultsController?.objectAtIndexPath(indexPath) as? Borrower {
            var name: String?
            var borrowings = [Borrowed]()
            borrower.managedObjectContext?.performBlockAndWait {
                name = borrower.name
                borrowings = (borrower.borrowings?.allObjects as? [Borrowed])!
            }
            cell.textLabel?.text = "\(name!) "
            cell.detailTextLabel?.text = balanceMessageWithBorrowerName(name!, borrowings: borrowings, andCurrency: self.currncy)
        }
        cell.selectionStyle = .None
        return cell
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            if let borrower = fetchedResultsController?.objectAtIndexPath(indexPath) as? Borrower {
                borrower.managedObjectContext?.performBlockAndWait {
                    borrower.managedObjectContext?.deleteObject(borrower)
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

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let borrower = fetchedResultsController?.objectAtIndexPath(indexPath) as? Borrower {
            var name: String?
            borrower.managedObjectContext?.performBlockAndWait {
                name = borrower.name
            }
            selectedBorrowerName = name!
            self.performSegueWithIdentifier("FromBorrowerToBorrowings", sender: self)
        }
    }

    
}
