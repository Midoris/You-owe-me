//
//  CoreDataTableViewController.swift
//  You owe me
//
//  Created by тигренок  on 08/08/2016.
//  Copyright © 2016 Iablonskyi Ievgenii. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    /*
     When you want to subclass from CoreDataTableViewController you need to set tableView and override cellForRowAtIndexPath method.
    */
    
    // MARK: - Variabels
    var fetchedResultsController : NSFetchedResultsController<Borrowed>? {
        didSet {
            do {
                if let frc = fetchedResultsController {
                    frc.delegate = self
                    try frc.performFetch()
                }
                tableView!.reloadData()
            } catch let error {
                print("NSFetchedResultsController.performFetch() faild: \(error)")
            }
        }
    }

    var borrowerFetchedResultsController : NSFetchedResultsController<Borrower>? {
        didSet {
            do {
                if let frc = borrowerFetchedResultsController {
                    frc.delegate = self
                    try frc.performFetch()
                }
                tableView!.reloadData()
            } catch let error {
                print("NSFetchedResultsController.performFetch() faild: \(error)")
            }
        }
    }

    
    var tableView: UITableView? {
        didSet {
            tableView?.delegate = self
            tableView?.dataSource = self
        }
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return borrowerFetchedResultsController?.sections?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = borrowerFetchedResultsController?.sections , sections.count > 0 {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
             let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
          return cell
    }

    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if let sections = borrowerFetchedResultsController?.sections , sections.count > 0 {
            return sections[section].name
        } else {
            return nil
        }
    }
    
    func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return borrowerFetchedResultsController?.sectionIndexTitles
    }
    
    func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return borrowerFetchedResultsController?.section(forSectionIndexTitle: title, at: index) ?? 0
    }
    
    // MARK: - NSFetchedResultsControllerDelegate
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView!.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView!.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert: tableView!.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete: tableView!.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView!.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView!.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableView!.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableView!.deleteRows(at: [indexPath!], with: .fade)
            tableView!.insertRows(at: [newIndexPath!], with: .fade)
        }
    }
    
    
}
