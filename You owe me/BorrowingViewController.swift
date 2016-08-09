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
    internal var name = "Mashka"/*"Mashka"*/ { didSet { updateUI() } } // set from privius VC as  var name: String?
    internal let currency = "฿"
    // This will be on the privius VC
    var managedObjectCOntext: NSManagedObjectContext? =
    (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    // set from privius VC
    /* var managedObjectCOntext: NSManagedObjectContext? { didSet { updateUI() } } */
    
    
    // Outlets
    @IBOutlet weak private var borrowingHistoryTableView: UITableView! {
        didSet {
            self.tableView = borrowingHistoryTableView
//            self.borrowingHistoryTableView.delegate = self
//            self.borrowingHistoryTableView.dataSource = self
        }
    }
    @IBOutlet weak private var borrowMessageLabel: UILabel! {
        didSet {
            // set message label
            borrowMessageLabel.text = borrowingModel.switchMessageWithName(self.name)
        }
    }
    @IBOutlet weak private var currencyLabel: UILabel! {
        didSet {
            currencyLabel.text = self.currency
        }
    }
    @IBOutlet weak var balanceLabel: UILabel! {
        didSet {
            self.balanceLabel.text = borrowingModel.getBalanceMessageWithFriend(self.name, andCurrency: self.currency)
        }
    }
    @IBOutlet weak private var amountTextField: UITextField!
    @IBOutlet weak private var submitButton: UIButton!
    @IBOutlet weak private var switchButton: UIButton!
    
    
    // Model
    let borrowingModel = BorrowingModel()
    
    // MARK: - ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BorrowingViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Add notofication observer fo updateing UI
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BorrowingViewController.updateUI), name: BorrowingVCConstants.UpdateUI, object: nil)
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // remove notification observer
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Class methods
    // resign the first responder
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc private func updateUI(){
        if let context = managedObjectCOntext where self.name.characters.count > 0 {
            let request = NSFetchRequest(entityName: "Borrowed")
            request.predicate = NSPredicate(format: "borrower.name = %@", self.name) // borrowed.borrower.name // "any borrowerName = %@"
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
        
        
        
//        self.borrowingHistoryTableView.reloadData()
//        self.balanceLabel.text = borrowingModel.getBalanceMessageWithFriend(self.name, andCurrency: self.currency)
    }
    
    private func updateDataBase() {
        managedObjectCOntext?.performBlock {
            // create a new borrowed
            if self.amountTextField.text != "" {
                let amount = Double(self.amountTextField.text!)
                let date = NSDate()
                _ = Borrowed.borrowedWithInfo(self.name, iBorrowed: true, currency: self.currency, amount: amount!, date: date,  inManagedObgectContext: self.managedObjectCOntext!)
                do {
                    try self.managedObjectCOntext?.save()
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
            print("\(borrowedCount) borroweds")
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
        borrowMessageLabel.text = borrowingModel.switchMessageWithName(self.name)
    }
    
       

}

