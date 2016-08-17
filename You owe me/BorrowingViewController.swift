//
//  ViewController.swift
//  You owe me
//
//  Created by тигренок  on 02/08/2016.
//  Copyright © 2016 Midori.s. All rights reserved.
//

import UIKit
import CoreData

class BorrowingViewController: CoreDataTableViewController {
    
    // MARK: - Variabels
    internal var name: String? //{ didSet { updateUI() } }
    internal var currency: String? //{ didSet { updateUI() } }


    var managedObjectCOntext: NSManagedObjectContext? //{ didSet { updateUI() } } //{ didSet { updateUI() } }
    
    // Outlets
    @IBOutlet weak private var borrowingHistoryTableView: UITableView! {
        didSet {
            self.tableView = borrowingHistoryTableView
        }
    }
    @IBOutlet weak private var borrowMessageLabel: UILabel! {
        didSet {
            borrowMessageLabel.text = borrowingModel.switchedMessageWithName(self.name!)
        }
    }
    @IBOutlet weak private var currencyLabel: UILabel! {
        didSet {
            currencyLabel.text = self.currency
        }
    }
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak private var amountTextField: UITextField!
    @IBOutlet weak private var submitButton: UIButton!
    @IBOutlet weak private var switchButton: UIButton!
    
    
    // Model
    let borrowingModel = BorrowingModel()
    
    // MARK: - ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsDisplay()
    }

    // MARK: - Methods
    private func setNeedsDisplay() {
        self.view.backgroundColor = BorrowingConstants.BackgroundColor
        self.borrowingHistoryTableView.backgroundColor = BorrowingConstants.BackgroundColor
        borrowingHistoryTableView.separatorColor = BorrowingConstants.NavBarColor
        updateUI()
        //Looks for single or multiple taps to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BorrowingViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func showKeyboard() {
        print("Show keyboard")
        self.amountTextField.becomeFirstResponder()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func updateUI(){
        if let context = managedObjectCOntext where self.name!.characters.count > 0 {
            let request = NSFetchRequest(entityName: "Borrowed")
            request.predicate = NSPredicate(format: "borrower.name = %@", self.name!)
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending:  false)]
            self.fetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        } else {
            fetchedResultsController = nil
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.updateBalanceLabel()
        })
    }
    
    private func updateDataBase() {
        managedObjectCOntext?.performBlock {
            // create a new borrowed
            if self.amountTextField.text != "" {
                let amount = Double(self.amountTextField.text!)
                let date = NSDate()
                _ = Borrowed.borrowedWithInfo(self.name!, iBorrowed: self.borrowingModel.iBorrowed, currency: self.currency!, amount: amount!, date: date,  inManagedObgectContext: self.managedObjectCOntext!)
                do {
                    try self.managedObjectCOntext?.save()
                    self.updateBalanceLabel()
                } catch let error {
                    print("Core Data Error: \(error)")
                    // TODO: Notify User
                }
            }
            self.clean()
        }
        printDatabaseStatistics()
    }
    
    private func printDatabaseStatistics() {
        managedObjectCOntext?.performBlock {
            if let results = try? self.managedObjectCOntext!.executeFetchRequest(NSFetchRequest(entityName: "Borrower")) {
                print("\(results.count) Borrowers")
            }
            // a more efficient way to count objects
            let borrowedCount = self.managedObjectCOntext!.countForFetchRequest(NSFetchRequest(entityName: "Borrowed"), error: nil)
            print("\(borrowedCount) borrowings")
        }
    }
        
    internal func updateBalanceLabel() {
        if let borrowings = fetchedResultsController?.fetchedObjects as? [Borrowed] {
            self.balanceLabel.text = borrowingModel.balanceMessageWithBorrowerName(self.name!, borrowings: borrowings, andCurrency: self.currency!)
        }
    }
    
    private func clean() {
        dispatch_async(dispatch_get_main_queue()) {
            self.dismissKeyboard()
            self.amountTextField.text = nil
        }
    }
    
    // MARK: - Actions from storyBoard
    // Submit button
    @IBAction private func submittPressed(sender: UIButton) {
        updateDataBase()
    }
    
    @IBAction private func switchButtonPressed(sender: UIButton) {
        borrowMessageLabel.text = borrowingModel.switchedMessageWithName(self.name!)
    }
    
    @IBAction private func clearAllButtonPressed(sender: UIButton) {
        if let results = fetchedResultsController?.fetchedObjects {
            for result in results {
                if let borrowed = result as? Borrowed {
                    borrowed.managedObjectContext?.performBlock {
                        borrowed.managedObjectContext?.deleteObject(borrowed)
                        do {
                            try self.managedObjectCOntext!.save()
                        } catch let error {
                            print("Core Data Error: \(error)")
                            // TODO: Notify User
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), {
                    self.updateBalanceLabel()
                })
            }
        }
    }
    
    @IBAction private func splitBillButtonPressed(sender: UIButton) {
        if self.amountTextField.text != "" {
            if let ammount = Double(amountTextField.text!) {
                self.amountTextField.text = borrowingModel.stringFromDoubleWithTailingZeroAndRounding(ammount / 2)
            }
        }
    }
    

    
    
}

