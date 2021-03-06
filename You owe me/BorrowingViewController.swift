//
//  ViewController.swift
//  You owe me
//
//  Created by тигренок  on 02/08/2016.
//  Copyright © 2016 Iablonskyi Ievgenii. All rights reserved.
//

import UIKit
import CoreData

class BorrowingViewController: CoreDataTableViewController {
    
    // MARK: - Variabels
    internal var borrowerName: String?
    internal var currency: String?
    internal var comeFrom3DTouch = false
    internal var managedObjectContext: NSManagedObjectContext?
    
    // Outlets
    @IBOutlet weak private var borrowingHistoryTableView: UITableView! {
        didSet {
            self.tableView = borrowingHistoryTableView
        }
    }
    @IBOutlet weak private var borrowMessageLabel: UILabel! {
        didSet {
            borrowMessageLabel.text = borrowingModel.switchedMessage(with: self.borrowerName!)
        }
    }
    @IBOutlet weak private var currencyLabel: UILabel! {
        didSet {
            currencyLabel.text = self.currency
        }
    }
    @IBOutlet weak private var balanceLabel: UILabel!
    @IBOutlet weak private var amountTextField: UITextField!
    @IBOutlet weak private var submitButton: UIButton!
    @IBOutlet weak private var switchButton: UIButton!
    @IBOutlet weak private var splitButton: UIButton!
    @IBOutlet weak private var doubleButton: UIButton!
    
    
    // Model
    let borrowingModel = BorrowingModel()
    
    // MARK: - ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsDisplay()
    }
    
    // MARK: - Methods
    fileprivate func setNeedsDisplay() {
        self.view.backgroundColor = BorrowingConstants.BackgroundColor
        self.borrowingHistoryTableView.backgroundColor = BorrowingConstants.BackgroundColor
        borrowingHistoryTableView.separatorColor = BorrowingConstants.NavBarColor
        updateUI()
        // decide to show or not keyboard.
        if comeFrom3DTouch {
            showKeyboard()
        }
        //Look for single or multiple taps to dismiss keyboard.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BorrowingViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // set buttons.
        setBorderAndColors(for: submitButton, splitButton, doubleButton, switchButton)
    }
    
    fileprivate func showKeyboard() {
        self.amountTextField.becomeFirstResponder()
    }
    
    @objc fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
    
    fileprivate func updateUI(){
        if let context = managedObjectContext , self.borrowerName!.characters.count > 0 {
            let request: NSFetchRequest<Borrowed> = Borrowed.fetchRequest()
            request.predicate = NSPredicate(format: "borrower.name = %@", self.borrowerName!)
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending:  false)]
            self.borrowedFetchedResultsController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: context,
                sectionNameKeyPath: nil,
                cacheName: nil
            )
        } else {
            borrowerFetchedResultsController = nil
        }
        DispatchQueue.main.async(execute: {
            self.updateBalanceLabel()
        })
    }
    
    private func updateDatabase() {
        managedObjectContext?.perform {
            // create a new borrowed.
            if self.amountTextField.text != "" {
                let amount = Double(self.amountTextField.text!)
                let date = Date()
                _ = Borrowed.borrowedWithInfo(self.borrowerName!, iBorrowedState: self.borrowingModel.iBorrowedState, currency: self.currency!, amount: amount!, date: date,  inManagedObgectContext: self.managedObjectContext!)
                do {
                    try self.managedObjectContext?.save()
                    self.updateBalanceLabel()
                } catch let error {
                    print("Core Data Error: \(error)")
                    // Notify User
                    SharedFunctions.showErrorAlert(in: self)
                }
            }
            self.clean()
        }
        // Uncomment if you want to see Database Statistics.
        //printDatabaseStatistics()
    }
    
    private func printDatabaseStatistics() {
        managedObjectContext?.perform {
            let borrowersCount = try? self.managedObjectContext!.count(for: NSFetchRequest(entityName: "Borrower"))
            print("\(borrowersCount) borrowers")
            let borrowedCount = try? self.managedObjectContext!.count(for: NSFetchRequest(entityName: "Borrowed"))
            print("\(borrowedCount) borrowings")
        }
    }
    
    func updateModifiedDate(for borrowerName: String) {
        managedObjectContext?.perform {
            let date = Date()
            _ = Borrower.borrowerWithInfo(borrowerName, inManagedObgectContext: self.managedObjectContext!, date: date, currency: self.currency!)
            do {
                try self.managedObjectContext?.save()
            } catch let error {
                print("Core Data Error: \(error)")
                // Notify User.
                SharedFunctions.showErrorAlert(in: self)
            }
        }
    }
    
    internal func updateBalanceLabel() {
        if let borrowings = borrowedFetchedResultsController?.fetchedObjects as [Borrowed]? {
            self.balanceLabel.text = SharedFunctions.balanceMessage(with: self.borrowerName!, borrowings: borrowings, and: self.currency!)
        }
    }
    
    private func setTintedImage(for switchButton: UIButton) {
        let tintedImage = UIImage(named: "icon_switch")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
        switchButton.setImage(tintedImage, for: UIControlState())
        switchButton.tintColor = BorrowingConstants.DarkBlueColor
    }

    private func setBorderAndColors(for buttons: UIButton...) {
        for button in buttons {
            if button == switchButton {
                self.setTintedImage(for: button)
            }
            button.layer.borderWidth = 1
            button.layer.borderColor = BorrowingConstants.DarkBlueColor.cgColor
            button.setTitleColor(BorrowingConstants.DarkBlueColor, for: UIControlState())
            button.layer.cornerRadius = button.layer.frame.height/2
        }
    }
    
    private func clean() {
        DispatchQueue.main.async {
            self.dismissKeyboard()
            self.amountTextField.text = nil
        }
    }
    
    // MARK: - Actions from storyBoard
    @IBAction private func submittPressed(_ sender: UIButton) {
        updateDatabase()
    }
    
    @IBAction private func switchButtonPressed(_ sender: UIButton) {
        borrowMessageLabel.text = borrowingModel.switchedMessage(with: self.borrowerName!)
    }
    
    @IBAction private func clearAllButtonPressed(_ sender: UIButton) {
        if let results = borrowedFetchedResultsController?.fetchedObjects {
            for result in results {
                if let borrowed = result as Borrowed? {
                    borrowed.managedObjectContext?.perform {
                        borrowed.managedObjectContext?.delete(borrowed)
                        do {
                            try self.managedObjectContext!.save()
                        } catch let error {
                            print("Core Data Error: \(error)")
                            // Notify User.
                            SharedFunctions.showErrorAlert(in: self)
                        }
                    }
                }
                DispatchQueue.main.async(execute: {
                    self.updateBalanceLabel()
                })
            }
        }
    }
    
    @IBAction private func calculateAmountButtonPressed(_ sender: UIButton) {
        if self.amountTextField.text != "" {
            if let amount = Double(amountTextField.text!) {
                self.amountTextField.text = borrowingModel.calculatedAmount(amount, dependingOnTag: sender.tag)
            }
        }
    }
        
}

