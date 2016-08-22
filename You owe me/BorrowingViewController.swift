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
    internal var comeFrom3DTouch = false
    
    
    var managedObjectContext: NSManagedObjectContext? //{ didSet { updateUI() } } //{ didSet { updateUI() } }
    
    // Outlets
    @IBOutlet weak private var borrowingHistoryTableView: UITableView! {
        didSet {
            self.tableView = borrowingHistoryTableView
        }
    }
    @IBOutlet weak private var borrowMessageLabel: UILabel! {
        didSet {
            borrowMessageLabel.text = sharedBorrowingModel.switchedMessageWithName(self.name!)
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
    @IBOutlet weak var splitButton: UIButton!
    @IBOutlet weak var doubleButton: UIButton!
    
    
    // Model
    let sharedBorrowingModel = BorrowingModel()
    
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
        // decide to show or not keyboard
        if comeFrom3DTouch {
            showKeyboard()
        }
        //Looks for single or multiple taps to dismiss keyboard
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BorrowingViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        setImageForSwitchButton()
        setBorderForButton(submitButton)
        setBorderForButton(splitButton)
        setBorderForButton(doubleButton)
    }
    
    private func showKeyboard() {
        self.amountTextField.becomeFirstResponder()
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func updateUI(){
        if let context = managedObjectContext where self.name!.characters.count > 0 {
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
    
    func updateDataBase() {
        managedObjectContext?.performBlock {
            // create a new borrowed
            if self.amountTextField.text != "" {
                let amount = Double(self.amountTextField.text!)
                let date = NSDate()
                _ = Borrowed.borrowedWithInfo(self.name!, iBorrowed: self.sharedBorrowingModel.iBorrowed, currency: self.currency!, amount: amount!, date: date,  inManagedObgectContext: self.managedObjectContext!)
                do {
                    try self.managedObjectContext?.save()
                    self.updateBalanceLabel()
                } catch let error {
                    print("Core Data Error: \(error)")
                    // Notify User
                    SheredFunctions.showErrorAlert(self)
                }
            }
            self.clean()
        }
        //printDatabaseStatistics()
    }
    
    private func printDatabaseStatistics() {
        managedObjectContext?.performBlock {
            let borrowersCount = self.managedObjectContext!.countForFetchRequest(NSFetchRequest(entityName: "Borrower"), error: nil)
            print("\(borrowersCount) borrowings")
            // a more efficient way to count objects
            let borrowedCount = self.managedObjectContext!.countForFetchRequest(NSFetchRequest(entityName: "Borrowed"), error: nil)
            print("\(borrowedCount) borrowings")
        }
    }
    
    func updateModifiedDateForBorrowerName(name: String) {
        managedObjectContext?.performBlock {
            let date = NSDate()
            _ = Borrower.borrowerWithInfo(name, inManagedObgectContext: self.managedObjectContext!, date: date, currency: self.currency!)
            do {
                try self.managedObjectContext?.save()
            } catch let error {
                print("Core Data Error: \(error)")
                // Notify User
                SheredFunctions.showErrorAlert(self)
            }
        }
    }
    
    internal func updateBalanceLabel() {
        if let borrowings = fetchedResultsController?.fetchedObjects as? [Borrowed] {
            self.balanceLabel.text = SheredFunctions.balanceMessageWithBorrowerName(self.name!, borrowings: borrowings, andCurrency: self.currency!)
        }
    }
    
    private func setImageForSwitchButton() {
        let tintedImage = UIImage(named: "icon_switch")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.switchButton.setImage(tintedImage, forState: .Normal)
        self.switchButton.tintColor = BorrowingConstants.DarkBlueColor
    }
    
    private func setBorderForButton(button: UIButton) {
        button.layer.borderWidth = 1
        button.layer.borderColor = BorrowingConstants.DarkBlueColor.CGColor
        button.layer.cornerRadius = 5
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
        borrowMessageLabel.text = sharedBorrowingModel.switchedMessageWithName(self.name!)
    }
    
    @IBAction private func clearAllButtonPressed(sender: UIButton) {
        if let results = fetchedResultsController?.fetchedObjects {
            for result in results {
                if let borrowed = result as? Borrowed {
                    borrowed.managedObjectContext?.performBlock {
                        borrowed.managedObjectContext?.deleteObject(borrowed)
                        do {
                            try self.managedObjectContext!.save()
                        } catch let error {
                            print("Core Data Error: \(error)")
                            // Notify User
                            SheredFunctions.showErrorAlert(self)
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
                self.amountTextField.text = sharedBorrowingModel.calculatedAmount(ammount, dependingOnTag: sender.tag)
            }
        }
    }
        
}

