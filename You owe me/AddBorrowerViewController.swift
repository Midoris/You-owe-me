//
//  AddBorrowerViewController.swift
//  You owe me
//
//  Created by тигренок  on 13/08/2016.
//  Copyright © 2016 Iablonskyi Ievgenii. All rights reserved.
//

import UIKit
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


protocol AddNewBorrowerDelegate: class {
    func saveNewBorrowerWithName(_ name: String, currency: String)
}

class AddBorrowerViewController: UIViewController, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    // MARK: - Variabels
    internal weak var addBorrowerDelegate: AddNewBorrowerDelegate?
    @IBOutlet weak fileprivate var borrowerNameTextField: UITextField! {
        didSet {
            self.borrowerNameTextField.delegate = self
            self.borrowerNameTextField.addTarget(self, action: #selector(AddBorrowerViewController.textFieldDidChange(_:)), for: .editingChanged)
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
    fileprivate let limitLength = 9
    fileprivate var currencyNames = [String]()
    fileprivate var selectedCurrency: String?
    
    // MARK: - ViewController Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showKeyboard()
        self.currencyNames = parsedCurrencyNames()
        saveButton.isEnabled = canSaveWhen(
            self.borrowerNameTextField.text?.characters.count > 0,
            andCurrencySelected: selectedCurrency != nil
        )
    }

    // MARK: - Text Field delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        return newLength <= limitLength
    }
    
    func textFieldDidChange(_ textField: UITextField) {
        saveButton.isEnabled = canSaveWhen(self.borrowerNameTextField.text?.characters.count > 0, andCurrencySelected: selectedCurrency != nil)
    }
    
    // MARK: - Picker delegate and data source
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyNames.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCurrency = BorrowingConstants.Currencies[currencyNames[row]]!
        selectedCurrencyLabel.text = selectedCurrency
        saveButton.isEnabled = canSaveWhen(
            self.borrowerNameTextField.text?.characters.count > 0,
            andCurrencySelected: selectedCurrency != nil
        )
    }
    
    // MARK: - Methods
    fileprivate func showKeyboard() {
        self.borrowerNameTextField.becomeFirstResponder()
    }
    
    fileprivate func dismissKeyboard() {
        view.endEditing(true)
    }
    
    fileprivate func canSaveWhen(_ textFieldIsNotEmpty: Bool, andCurrencySelected selected: Bool) -> Bool {
        guard textFieldIsNotEmpty && selected else { return false }
        return true
    }
    
    fileprivate func parsedCurrencyNames() -> [String] {
        var currencyNames = [String]()
        for (currencyName,_) in BorrowingConstants.Currencies {
            currencyNames.append(currencyName)
        }
        return currencyNames.sorted()
    }
    
    fileprivate func dismissVC() {
        dismissKeyboard()
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - StoryBoard Methods
    @IBAction fileprivate func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismissVC()
    }
    
    @IBAction fileprivate func saveButtonPressed(_ sender: UIBarButtonItem) {
        // Trim spaces from the name.
        let name = borrowerNameTextField.text!.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines
        )
        addBorrowerDelegate?.saveNewBorrowerWithName(name, currency: selectedCurrency!)
        dismissVC()
    }
    
}
