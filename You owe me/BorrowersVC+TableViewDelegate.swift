//
//  BorrowersVC+TableViewDelegate.swift
//  You owe me
//
//  Created by тигренок  on 12/08/2016.
//  Copyright © 2016 Iablonskyi Ievgenii. All rights reserved.
//

import Foundation
import UIKit

extension BorrowersViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BorrowingConstants.BorrowerCellID, for: indexPath)
        if let borrower = fetchedResultsController?.object(at: indexPath) as? Borrower {
            var name: String?
            var currncy: String?
            var borrowings = [Borrowed]()
            borrower.managedObjectContext?.performAndWait {
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
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAtIndexPath indexPath: IndexPath) -> [AnyObject]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            if let borrower = self.fetchedResultsController?.object(at: indexPath) as? Borrower {
                borrower.managedObjectContext?.performAndWait {
                    borrower.managedObjectContext?.delete(borrower)
                    do {
                        try self.managedObjectContext!.save()
                    } catch let error {
                        print("Core Data Error: \(error)")
                        // Notify User.
                        SharedFunctions.showErrorAlert(self)
                    }
                }
            }
        }
        delete.backgroundColor = BorrowingConstants.DarkRedColor
        return [delete]
    }

    
    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
        if let borrower = fetchedResultsController?.object(at: indexPath) as? Borrower {
            var name: String?
            var currency: String?
            borrower.managedObjectContext?.performAndWait {
                name = borrower.name
                currency = borrower.currency
            }
            selectedBorrowerName = name!
            borrowerCurrncy = currency!
            self.performSegue(withIdentifier: BorrowingConstants.FromBorrowerToBorrowingsSegueID, sender: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
