//
//  ViewController.swift
//  You owe me
//
//  Created by тигренок  on 02/08/2016.
//  Copyright © 2016 Midori.s. All rights reserved.
//

import UIKit
import CoreData

class BorrowingViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    
    // MARK: - NSFetchedResultsController
    var fetchedResultsController : NSFetchedResultsController? {
        didSet {
            do {
                if let frc = fetchedResultsController {
                    frc.delegate = self
                    try frc.performFetch()
                }
                self.borrowingHistoryTableView.reloadData()
            } catch let error {
                print("NSFetchedResultsController.performFetch() faild: \(error)")
            }
        }
    }
    
    
    // MARK: - UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("fetchedResultsController?.sections?.count = \(fetchedResultsController?.sections?.count)")
        return fetchedResultsController?.sections?.count ?? 1
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections where sections.count > 0 {
            print("sections[section].numberOfObjects = \(sections[section].numberOfObjects)")
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = fetchedResultsController?.sections where sections.count > 0 {
            return sections[section].name
        } else {
            return nil
        }
    }
    
    func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return fetchedResultsController?.sectionIndexTitles
    }
    
    func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return fetchedResultsController?.sectionForSectionIndexTitle(title, atIndex: index) ?? 0
    }
    
    
    
    // DELETE
     func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            
            if let borrowed = fetchedResultsController?.objectAtIndexPath(indexPath) as? Borrowed {
                borrowed.managedObjectContext?.performBlockAndWait {
                    borrowed.managedObjectContext?.deleteObject(borrowed)
                    //borrowed.managedObjectContext?.save()
                    do {
                        try self.managedObjectCOntext!.save()
                    } catch let error {
                        print("Core Data Error: \(error)")
                        // TODO: Notify User
                    }

                }
              
            }

            //self.borrowingHistoryTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.borrowingHistoryTableView.beginUpdates()
        //self.borrowingHistoryTableView.reloadData() //beginUpdates()
        self.borrowingHistoryTableView.endUpdates()
    }
    
    func controller(controller: NSFetchedResultsController, didChangeSection sectionInfo: NSFetchedResultsSectionInfo, atIndex sectionIndex: Int, forChangeType type: NSFetchedResultsChangeType) {
        switch type {
        case .Insert: borrowingHistoryTableView.insertSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        case .Delete: borrowingHistoryTableView.deleteSections(NSIndexSet(index: sectionIndex), withRowAnimation: .Fade)
        default: break
        }
    }
    
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            borrowingHistoryTableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        case .Delete:
            borrowingHistoryTableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Update:
            borrowingHistoryTableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
        case .Move:
            borrowingHistoryTableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: .Fade)
            borrowingHistoryTableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Fade)
        }
    }
    
    
    
    
    
    
    
    
    
    
    

    
    // MARK: - Variabels
    internal var name = "Mashka" { didSet { updateUI() } } // set from privius VC as  var name: String?
    internal let currency = "฿"
    // This will be on the privius VC
    var managedObjectCOntext: NSManagedObjectContext? =
    (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext
    
    // set from privius VC
    /* var managedObjectCOntext: NSManagedObjectContext? { didSet { updateUI() } } */
    
    
    // Outlets
    @IBOutlet weak private var borrowingHistoryTableView: UITableView! {
        didSet {
            self.borrowingHistoryTableView.delegate = self
            self.borrowingHistoryTableView.dataSource = self
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //updateUI()
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
            //request.predicate = NSPredicate(format: "any borrowed.borrower.name = %@", self.name)
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
        //printDatabaseStatistics()
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
//    }
    
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
//        if self.amountTextField.text != "" {
//            let amount = Double(self.amountTextField.text!)
//            borrowingModel.createNewBorrowedItemWithFriend(self.name, amount: amount!, andCurrency: self.currency)
//            self.dismissKeyboard()
//            self.amountTextField.text = nil
//        }
    }
    
    @IBAction private func switchButtonPressed(sender: UIButton) {
        borrowMessageLabel.text = borrowingModel.switchMessageWithName(self.name)
    }
    
       

}

