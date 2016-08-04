//
//  ViewController.swift
//  You owe me
//
//  Created by тигренок  on 02/08/2016.
//  Copyright © 2016 Midori.s. All rights reserved.
//

import UIKit

class BorrowingViewController: UIViewController {
    
    // MARK: - Variabels
    internal let name = "Mashka"
    internal let currency = "฿"
    
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
            borrowMessageLabel.text = borrowingModel.getMessageWithName(self.name)
        }
    }
    @IBOutlet weak private var currencyLabel: UILabel! {
        didSet {
            currencyLabel.text = self.currency
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
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(BorrowingViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        // Add notofication observer fo updateing UI
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(BorrowingViewController.updateUI(_:)), name:"UpdateUI", object: nil)
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
    
    @objc private func updateUI(notification: NSNotification){
        self.borrowingHistoryTableView.reloadData()
    }

    
    // MARK: - Actions from storyBoard
    // Submit button
    @IBAction private func submittPressed(sender: UIButton) {
        if self.amountTextField.text != "" {
            let amount = Double(self.amountTextField.text!)
            borrowingModel.createNewBorrowedItemWithMessage(self.borrowMessageLabel.text!, amount: amount!, currency: self.currency)
            self.dismissKeyboard()
            self.amountTextField.text = nil
        }
    }
    
    @IBAction private func switchButtonPressed(sender: UIButton) {
        borrowMessageLabel.text = borrowingModel.getMessageWithName(self.name)
    }
}

