//
//  AddBorrowerViewController.swift
//  You owe me
//
//  Created by тигренок  on 13/08/2016.
//  Copyright © 2016 Midori.s. All rights reserved.
//

import UIKit

protocol AddNewBorrowerDelegate: class {
    func saveNewBorrowerWithName(name: String)
}

class AddBorrowerViewController: UIViewController, UITextFieldDelegate {
    
    // MARK: - Variabels
    @IBOutlet weak var borrowerNameTextField: UITextField! {
        didSet {
            self.borrowerNameTextField.delegate = self
        }
    }
    internal weak var addBorrowerDelegate: AddNewBorrowerDelegate?
    let limitLength = 12

    // MARK: - ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Text Field delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
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
