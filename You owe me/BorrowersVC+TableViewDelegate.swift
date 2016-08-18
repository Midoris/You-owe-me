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
            var borrowings = [Borrowed]()
            borrower.managedObjectContext?.performBlockAndWait {
                name = borrower.name
                borrowings = (borrower.borrowings?.allObjects as? [Borrowed])!
            }
            cell.textLabel?.text = "\(name!)"
            cell.textLabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(22))
            cell.textLabel?.textColor = BorrowingConstants.LargeTextColor
            let balanceMessage = borrowingModel.balanceMessageWithBorrowerName(name!, borrowings: borrowings, andCurrency: self.currncy)
            cell.detailTextLabel?.text = balanceMessage
            cell.detailTextLabel?.font = UIFont(name: "HelveticaNeue", size: CGFloat(13.5))
            cell.detailTextLabel?.textColor = BorrowingConstants.SmallTextColor
        }
        cell.selectionStyle = .None
        cell.backgroundColor = UIColor.clearColor()
        return cell
    }
    
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if editingStyle == UITableViewCellEditingStyle.Delete {
//            if let borrower = fetchedResultsController?.objectAtIndexPath(indexPath) as? Borrower {
//                borrower.managedObjectContext?.performBlockAndWait {
//                    borrower.managedObjectContext?.deleteObject(borrower)
//                    do {
//                        try self.managedObjectCOntext!.save()
//                    } catch let error {
//                        print("Core Data Error: \(error)")
//                        // TODO: Notify User
//                    }
//                }
//            }
//        }
//    }
    
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
        /*
         let edite = UITableViewRowAction(style: .Normal, title: "Edite") { action, index in
         print("edite button tapped")
         }
         edite.backgroundColor = UIColor.grayColor()
         */
        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
            if let borrower = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? Borrower {
                borrower.managedObjectContext?.performBlockAndWait {
                    borrower.managedObjectContext?.deleteObject(borrower)
                    do {
                        try self.managedObjectContext!.save()
                    } catch let error {
                        print("Core Data Error: \(error)")
                        // TODO: Notify User
                    }
                }
            }
        }
        delete.backgroundColor = BorrowingConstants.DarkRedColor
        return [delete/*, edite*/]
    }

    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let borrower = fetchedResultsController?.objectAtIndexPath(indexPath) as? Borrower {
            var name: String?
            borrower.managedObjectContext?.performBlockAndWait {
                name = borrower.name
            }
            selectedBorrowerName = name!
            self.performSegueWithIdentifier(BorrowingConstants.FromBorrowerToBorrowingsSegueID, sender: self)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 70
    }
    
}
