//
//  CoreDataTableViewController.swift
//  You owe me
//
//  Created by тигренок  on 08/08/2016.
//  Copyright © 2016 Midori.s. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataTableViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var fetchedResultsController : NSFetchedResultsController? {
        didSet {
            do {
                if let frc = fetchedResultsController {
                    frc.delegate = self
                    try frc.performFetch()
                }
                tableView.reloadData()
            } catch let error {
                print("NSFetchedResultsController.performFetch() faild: \(error)")
            }
        }
    }
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return fetchedResultsController?.sections?.count ?? 1
    }
    
    
}
