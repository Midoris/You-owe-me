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
        let cell = tableView.dequeueReusableCellWithIdentifier(BorrowingConstants.BorrowingHistoryCellID, forIndexPath: indexPath)
        if let borrowed = fetchedResultsController?.objectAtIndexPath(indexPath) as? Borrowed {
            var name: String?
            var date: NSDate?
            var amount: Double?
            var currency: String?
            var iBorrowed: Bool?
            borrowed.managedObjectContext?.performBlockAndWait {
                name = borrowed.borrower!.name
                date = borrowed.date
                amount = Double(borrowed.amount!)
                currency = borrowed.currency!
                iBorrowed = Bool(borrowed.iBorrowed!)
            }
            let message = borrowingModel.messageWithBorrowingState(iBorrowed!, andName: name!)
            cell.textLabel?.text = "\(message) \(borrowingModel.stringFromDoubleWithTailingZero(amount!)) \(currency!) "
            cell.detailTextLabel?.text = borrowingModel.dateStringFromDate(date!)
        }
        cell.selectionStyle = .None
        return cell
    }
    
        func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
            if editingStyle == .Delete {
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
                    dispatch_async(dispatch_get_main_queue(), {
                        self.updateBalanceLabel()
                    })
                }
            }
         }
    
//    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [AnyObject]? {
//        let edite = UITableViewRowAction(style: .Normal, title: "Edite") { action, index in
//            print("edite button tapped")
//        
//            
//        }
//        edite.backgroundColor = UIColor.grayColor()
//        let delete = UITableViewRowAction(style: .Normal, title: "Delete") { action, index in
//            if let borrowed = self.fetchedResultsController?.objectAtIndexPath(indexPath) as? Borrowed {
//                borrowed.managedObjectContext?.performBlockAndWait {
//                    borrowed.managedObjectContext?.deleteObject(borrowed)
//                    do {
//                        try self.managedObjectCOntext!.save()
//                    } catch let error {
//                        print("Core Data Error: \(error)")
//                        // TODO: Notify User
//                    }
//                }
//                dispatch_async(dispatch_get_main_queue(), {
//                    self.updateBalanceLabel()
//                })
//            }
//        }
//        delete.backgroundColor = UIColor.redColor()
//        return [delete, edite]
//    }
    
    
    
}
