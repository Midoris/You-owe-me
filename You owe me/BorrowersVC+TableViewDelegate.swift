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
            borrower.managedObjectContext?.performBlockAndWait {
                name = borrower.name
            }
            cell.textLabel?.text = "\(name!) "
        }
        return cell
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
