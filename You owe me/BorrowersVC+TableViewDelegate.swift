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
        let cell = tableView.dequeueReusableCellWithIdentifier(BorrowingConstants.BorrowerCellID, forIndexPath: indexPath)
        if let borrower = fetchedResultsController?.objectAtIndexPath(indexPath) as? Borrower {
            var name: String?
            var currncy: String?
            var borrowings = [Borrowed]()
            borrower.managedObjectContext?.performBlockAndWait {
                name = borrower.name
                currncy = borrower.currency
                borrowings = (borrower.borrowings?.allObjects as? [Borrowed])!
            }
            cell.textLabel?.text = "\(name!)"
            cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(22))
            cell.textLabel?.textColor = BorrowingConstants.LargeTextColor
            let balanceMessage = SharedFunctions.balanceMessageWithBorrowerName(name!, borrowings: borrowings, andCurrency: currncy!)
            cell.detailTextLabel?.text = balanceMessage
            cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(13.5))
            cell.detailTextLabel?.textColor = BorrowingConstants.SmallTextColor
        }
        cell.selectionStyle = .None
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            if let borrower = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? Borrower {
                borrower.managedObjectContext?.performBlockAndWait {
                    borrower.managedObjectContext?.deleteObject(borrower)
                    do {
                        try self.managedObjectContext!.save()
                    } catch let error {
                        print("Core Data Error: \(error)")
                        // Notify User
                        SharedFunctions.showErrorAlert(self)
                    }
                }
            }
        }
        delete.backgroundColor = BorrowingConstants.DarkRedColor
        return [delete]
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let borrower = fetchedResultsController?.objectAtIndexPath(indexPath) as? Borrower {
            var name: String?
            var currency: String?
            borrower.managedObjectContext?.performBlockAndWait {
                name = borrower.name
                currency = borrower.currency
            }
            selectedBorrowerName = name!
            borrowerCurrncy = currency!
            self.performSegueWithIdentifier(BorrowingConstants.FromBorrowerToBorrowingsSegueID, sender: self)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
}
