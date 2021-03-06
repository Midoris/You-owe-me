//
//  BorrowingVC Extension + TableView.swift
//  You owe me
//
//  Created by тигренок  on 02/08/2016.
//  Copyright © 2016 Iablonskyi Ievgenii. All rights reserved.
//

import Foundation
import UIKit
import CoreData

extension BorrowingViewController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BorrowingConstants.BorrowingHistoryCellID, for: indexPath)
        if let borrowed = borrowedFetchedResultsController?.object(at: indexPath) as Borrowed? {
            var borrowerName: String?
            var date: Date?
            var amount: Double?
            var currency: String?
            var iBorrowedState: Bool?
            borrowed.managedObjectContext?.performAndWait {
                borrowerName = borrowed.borrower!.name
                date = borrowed.date
                amount = Double(borrowed.amount!)
                currency = borrowed.currency!
                iBorrowedState = Bool(borrowed.iBorrowed!)
            }
            let message = borrowingModel.message(with: iBorrowedState!, and: borrowerName!)
            cell.textLabel?.text = "\(message) \(SharedFunctions.stringFromDoubleWithTailingZeroAndRounding(amount!)) \(currency!)"
            cell.textLabel?.textColor = BorrowingConstants.LargeTextColor
            cell.detailTextLabel?.text = borrowingModel.dateString(from: date!)
            cell.detailTextLabel?.textColor = BorrowingConstants.SmallTextColor
        }
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAtIndexPath indexPath: IndexPath) -> [AnyObject]? {
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            if let borrowed = self.borrowedFetchedResultsController?.object(at: indexPath) as Borrowed? {
                borrowed.managedObjectContext?.performAndWait {
                    borrowed.managedObjectContext?.delete(borrowed)
                    do {
                        try self.managedObjectContext!.save()
                    } catch let error {
                        print("Core Data Error: \(error)")
                        // Notify User.
                        SharedFunctions.showErrorAlert(in: self)
                    }
                }
                DispatchQueue.main.async(execute: {
                    self.updateBalanceLabel()
                })
                self.updateModifiedDate(for: self.borrowerName!)
            }
        }
        delete.backgroundColor = BorrowingConstants.DarkRedColor
        return [delete]
    }
    
    
    
}
