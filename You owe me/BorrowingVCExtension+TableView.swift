//
//  BorrowingVC Extension + TableView.swift
//  You owe me
//
//  Created by тигренок  on 02/08/2016.
//  Copyright © 2016 Midori.s. All rights reserved.
//

import Foundation
import UIKit

extension BorrowingViewController: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - TableView DataSource and Delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return borrowingModel.borrowedItems.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let historyCell = tableView.dequeueReusableCellWithIdentifier(BorrowingVCConstants.BorrowingHistoryCellID)!
        let friendName = borrowingModel.borrowedItems[indexPath.row].friendName
        let borrowingState = borrowingModel.borrowedItems[indexPath.row].borrowingState
        let amount = borrowingModel.borrowedItems[indexPath.row].ammount
        let date = borrowingModel.borrowedItems[indexPath.row].date
        let currency = borrowingModel.borrowedItems[indexPath.row].currency
        let borrowingMessage = borrowingModel.getMessageWIthBorrowingState(borrowingState, name: friendName)
        historyCell.textLabel?.text = "\(borrowingMessage) \(amount) \(currency) on \(date)"
        return historyCell
    }
}
