//
//  Borrowers.swift
//  You owe me
//
//  Created by тигренок  on 09/08/2016.
//  Copyright © 2016 Midori.s. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BorrowersViewController: CoreDataTableViewController {
    
    // MARK: - Variabels
    @IBOutlet weak var borrowersTableView: UITableView! {
        didSet {
            self.tableView = borrowersTableView
        }
    }
    var managedObjectCOntext: NSManagedObjectContext? =
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var selectedBorrowerName: String?
    var currncy = "฿"
    
    
    
    // MARK: - ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BorrowersViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    // MARK: - Class methods
    // resign the first responder
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func updateUI(){
        if let context = managedObjectCOntext  {
            let request = NSFetchRequest(entityName: "Borrower")
            request.sortDescriptors = [NSSortDescriptor(key: "name", ascending:  true)]
            self.fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        } else {
            fetchedResultsController = nil
        }
    }
    
    private func updateDataBase() {
        managedObjectCOntext?.performBlock {
            // create a new borrower
            _ = Borrower.borrowerWithInfo("Maska", inManagedObgectContext: self.managedObjectCOntext!)
                do {
                    try self.managedObjectCOntext?.save()
                } catch let error {
                    print("Core Data Error: \(error)")
                    // TODO: Notify User
                }
            }
    }

    
    
    
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
    
    
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FromBorrowerToBorrowings" {
            if let borrowingVC = segue.destinationViewController as? BorrowingViewController {
                borrowingVC.managedObjectCOntext = self.managedObjectCOntext
                borrowingVC.name = self.selectedBorrowerName!
                borrowingVC.currency = self.currncy
            }
        }
    }
    
    
    
    
}