//
//  AddBorrowerViewController.swift
//  You owe me
//
//  Created by тигренок  on 13/08/2016.
//  Copyright © 2016 Midori.s. All rights reserved.
//

import UIKit

protocol AddNewBorrowerDelegate: class {
    func saveNewBorrowerWithName(name: String, currency: String)
}

class AddBorrowerViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Variabels
    internal weak var addBorrowerDelegate: AddNewBorrowerDelegate?
    @IBOutlet weak private var borrowerNameTextField: UITextField! {
        didSet {
            self.borrowerNameTextField.delegate = self
        }
    }
    @IBOutlet weak var currencyPicker: UIPickerView!{
        didSet {
            currencyPicker.delegate = self
            currencyPicker.dataSource = self
        }
    }
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var selectedCurrencyLabel: UILabel!
    private let limitLength = 9
    private var currencies = [String]()
    private var selectedCurrency: String?

    // MARK: - ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showKeyboard()
        self.currencies = parsedCurrencies()
        saveButton.enabled = false
    }
    
    // MARK: - Text Field delegate
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
    // MARK: - Picker delegate and data source
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = BorrowingConstants.Currencies[currencies[row]]!
        selectedCurrencyLabel.text = selectedCurrency
        saveButton.enabled = true
    }
    
    // MARK: - Methods
    private func showKeyboard() {
        self.borrowerNameTextField.becomeFirstResponder()
    }
    
    private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func parsedCurrencies() -> [String] {
        var currencies = [String]()
        for (currency,_) in BorrowingConstants.Currencies {
            currencies.append(currency)
        }
        return currencies.sort()
    }

    private func dismissVC() {
        dismissKeyboard()
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
            addBorrowerDelegate?.saveNewBorrowerWithName(name, currency: selectedCurrency!)
            dismissVC()
        }
    }
      
   
}
