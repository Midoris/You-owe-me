//
//  AddBorrowerViewController.swift
//  You owe me
//
//  Created by тигренок  on 13/08/2016.
//  Copyright © 2016 Midori.s. All rights reserved.
//

import UIKit

protocol AddNewBorrowerDelegate {
    func saveNewBorrowerWithName(name: String)
}

class AddBorrowerViewController: UIViewController {
    
    // MARK: - Variabels
    @IBOutlet weak var borrowerNameTextField: UITextField!
    internal var addBorrowerDelegate: AddNewBorrowerDelegate?

    // MARK: - ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Methods
    private func dismissVC() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - StoryBoard Methods
    @IBAction private func cancelButtonPressed(sender: UIBarButtonItem) {
        dismissVC()
    }
    
    @IBAction private func saveButtonPressed(sender: UIBarButtonItem) {
        if borrowerNameTextField.text!.characters.count > 0 {
            // Trim spaces from the name
            let name = borrowerNameTextField.text!.stringByTrimmingCharactersInSet(
                NSCharacterSet.whitespaceAndNewlineCharacterSet()
            )
            addBorrowerDelegate?.saveNewBorrowerWithName(name)
            dismissVC()
        }
    }
      
   
}
