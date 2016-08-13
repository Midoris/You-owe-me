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

class BorrowersViewController: CoreDataTableViewController, AddNewBorrowerDelegate {
    
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
    }
    
    // MARK: - Class methods
    @objc private func updateUI(){
        if let context = managedObjectCOntext  {
            let request = NSFetchRequest(entityName: "Borrower")
            request.sortDescriptors = [NSSortDescriptor(
                key: "name",
                ascending:  true,
                selector: #selector(NSString.localizedCaseInsensitiveCompare(_:))
                )]
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
    
    internal func saveNewBorrowerWithName(name: String) {
        managedObjectCOntext?.performBlock {
            // create a new borrower
            _ = Borrower.borrowerWithInfo(name, inManagedObgectContext: self.managedObjectCOntext!)
            do {
                try self.managedObjectCOntext?.save()
            } catch let error {
                print("Core Data Error: \(error)")
                // TODO: Notify User
            }
        }
    }
    
    
    
    
    func countedBalance(borrowings: [Borrowed]) -> Double {
        var balance = 0.0
        for borrowed in borrowings {
                let state = Bool(borrowed.iBorrowed!)
                let amount = Double(borrowed.amount!)
                switch state {
                case true : balance += amount
                case false: balance -= amount
            }
        }
        return balance
    }
    
    func balanceMessageWithBorrowerName(name: String, borrowings: [Borrowed], andCurrency currency: String) -> String {
        let balance = countedBalance(borrowings)
        switch balance {
        case let x where x > 0 :
            return "\(name) owe me \(abs(balance)) \(currency)"
        case let x where x < 0:
            return "I owe \(name) \(abs(balance)) \(currency)"
        default:
            return "clear balance"
        }
    }
    
    

    
    
    // MARK: - StoryBoard methods
    @IBAction private func addButtonAdded(sender: UIBarButtonItem) {
        performSegueWithIdentifier("addBorrower", sender: self)
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "FromBorrowerToBorrowings" {
            if let borrowingVC = segue.destinationViewController as? BorrowingViewController {
                borrowingVC.managedObjectCOntext = self.managedObjectCOntext
                borrowingVC.name = self.selectedBorrowerName!
                borrowingVC.currency = self.currncy
            }
        } else if segue.identifier == "addBorrower" {
            if let addBorrowerVC = segue.destinationViewController as? AddBorrowerViewController {
                addBorrowerVC.addBorrowerDelegate = self
            }
        }
    }
    
    
    
    
}