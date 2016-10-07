//
//  Borrowers.swift
//  You owe me
//
//  Created by тигренок  on 09/08/2016.
//  Copyright © 2016 Iablonskyi Ievgenii. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class BorrowersViewController: CoreDataTableViewController, AddNewBorrowerDelegate {

    
    // MARK: - Variabels
    var managedObjectContext: NSManagedObjectContext? =
        (UIApplication.shared.delegate as? AppDelegate)?.managedObjectContext
    var selectedBorrowerName: String?
    var borrowerCurrncy: String?
    var openedFrom3dTouch: Bool?
    
    @IBOutlet weak var borrowersTableView: UITableView! {
        didSet {
            self.tableView = borrowersTableView
        }
    }
    
    // MARK: - ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsDisplay()
        NotificationCenter.default.addObserver(self, selector: #selector(BorrowersViewController.saveBorrowersFor3DTouch), name:NSNotification.Name(rawValue: BorrowingConstants.SaveBorrowersFor3DTouch), object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.saveBorrowersFor3DTouch()
        // Set to nil so keyboard in Borrowing VC will be shown only if the app is opened from 3d Touch quick action.
        self.openedFrom3dTouch = nil
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Methods
    fileprivate func setNeedsDisplay() {
        self.view.backgroundColor = BorrowingConstants.BackgroundColor
        self.borrowersTableView.backgroundColor = BorrowingConstants.BackgroundColor
        self.borrowersTableView.separatorStyle = .none
        updateUI()
    }
    
    fileprivate func addShortcutItemsFromBorrowers(_ borrowers: [[String: String]]) {
        var quickItems = [UIApplicationShortcutItem]()
        for (index, borrower) in borrowers.enumerated() {
            if index < BorrowingConstants.QuickItemLimit {
                let title = borrower["name"]
                let subtitle = borrower["balanceMessage"]
                let shortcut = UIApplicationShortcutItem(type: "com.midori.s.You-owe-me", localizedTitle: title!, localizedSubtitle: subtitle, icon: UIApplicationShortcutIcon(type: .add), userInfo: nil)
                quickItems.append(shortcut)
            }
        }
        defer {
            // reverse sort and then save.
            quickItems = quickItems.reversed()
            UIApplication.shared.shortcutItems = quickItems
        }
    }
    
    @objc fileprivate func updateUI(){
        if let context = managedObjectContext  {
            //let request = NSFetchRequest(entityName: "Borrower")
            let request: NSFetchRequest<Borrower> = Borrower.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "modified", ascending:  false)]
            self.borrowerFetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        } else {
            borrowerFetchedResultsController = nil
        }
    }
    
    fileprivate func borrowersFromCoreData() -> [[String: String]]? {
        if let borrowers = borrowerFetchedResultsController?.fetchedObjects as [Borrower]? {
            var borrowersFor3DTouch = [[String: String]]()
            for borrower in borrowers {
                var name: String?
                var currncy: String?
                var borrowings = [Borrowed]()
                borrower.managedObjectContext?.performAndWait {
                    name = borrower.name
                    currncy = borrower.currency
                    borrowings = (borrower.borrowings?.allObjects as? [Borrowed])!
                }
                let balanceMessage = SharedFunctions.balanceMessageWithBorrowerName(name!, borrowings: borrowings, andCurrency: currncy!)
                borrowersFor3DTouch.append(["name": name!, "balanceMessage": balanceMessage])
            }
            return borrowersFor3DTouch
        }
        return nil
    }
    
    @objc fileprivate func saveBorrowersFor3DTouch() {
        let borrowers = borrowersFromCoreData()
        if borrowers != nil {
            // add borrowers to quick items and save.
            addShortcutItemsFromBorrowers(borrowers!)
        } else {
            // remove all quick items.
            UIApplication.shared.shortcutItems = []
        }
    }
    
    // MARK: - Add New Borrower Delegate
    internal func saveNewBorrowerWithName(_ name: String, currency: String) {
        managedObjectContext?.perform {
            // create a new borrower.
            let date = Date()
            _ = Borrower.borrowerWithInfo(name, inManagedObgectContext: self.managedObjectContext!, date: date, currency: currency)
            do {
                try self.managedObjectContext?.save()
            } catch let error {
                print("Core Data Error: \(error)")
                // Notify User.
                SharedFunctions.showErrorAlert(self)
            }
        }
    }
    
    // MARK: - StoryBoard methods
    @IBAction fileprivate func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: BorrowingConstants.AddBorrowerSegueId, sender: self)
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == BorrowingConstants.FromBorrowerToBorrowingsSegueID {
            if let borrowingVC = segue.destination as? BorrowingViewController {
                borrowingVC.managedObjectContext = self.managedObjectContext
                borrowingVC.name = self.selectedBorrowerName!
                borrowingVC.currency = self.borrowerCurrncy
                // decide to show or not keyboard in Borrowing VC.
                borrowingVC.comeFrom3DTouch = self.openedFrom3dTouch ?? false
            }
        } else if segue.identifier == BorrowingConstants.AddBorrowerSegueId {
            if let addBorrowerVC = segue.destination as? AddBorrowerViewController {
                addBorrowerVC.addBorrowerDelegate = self
            }
        }
    }
    
    
}
