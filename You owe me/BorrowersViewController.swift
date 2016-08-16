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
    var managedObjectCOntext: NSManagedObjectContext? =
        (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    var selectedBorrowerName: String?
    var currncy = "฿"
    
    @IBOutlet weak var borrowersTableView: UITableView! {
        didSet {
            self.tableView = borrowersTableView
        }
    }
    
    // Model
    let borrowingModel = BorrowingModel()
    
    // MARK: - ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsDisplay()
    }
    
    // MARK: - Methods
    private func setNeedsDisplay() {
        self.navigationController!.navigationBar.tintColor = BorrowingConstants.BlackColor
        updateUI()
        self.borrowersTableView.separatorStyle = UITableViewCellSeparatorStyle.None
    }
    
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
    
    // MARK: - Add New Borrower Delegate
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
    
    // MARK: - StoryBoard methods
    @IBAction private func addButtonAdded(sender: UIBarButtonItem) {
        performSegueWithIdentifier(BorrowingConstants.AddBorrowerSegueId, sender: self)
    }
    
    // MARK: - Segues
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == BorrowingConstants.FromBorrowerToBorrowingsSegueID {
            if let borrowingVC = segue.destinationViewController as? BorrowingViewController {
                borrowingVC.managedObjectCOntext = self.managedObjectCOntext
                borrowingVC.name = self.selectedBorrowerName!
                borrowingVC.currency = self.currncy
            }
        } else if segue.identifier == BorrowingConstants.AddBorrowerSegueId {
            if let addBorrowerVC = segue.destinationViewController as? AddBorrowerViewController {
                addBorrowerVC.addBorrowerDelegate = self
            }
        }
    }
    
    
    
    
}