//
//  EmailAddressViewController.swift
//  Axle
//
//  Created by Rajin Gangadharan on 10/04/25.
//

import UIKit

class EnterNameViewController: UIViewController {
    
    @IBOutlet weak var txtFirstName: UITextField!
    @IBOutlet weak var txtLastName: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        btnContinue.alpha = 0.4
        txtFirstName.setPadding(left: 16, right: 16)
        txtLastName.setPadding(left: 16, right: 16)
        
        txtFirstName.delegate = self
        txtLastName.delegate = self
    }
    
    func isValidFirstName(firstName: String) -> Bool {
        // Basic check: Non-empty and no excessive length
        guard !firstName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              firstName.count <= 50 else {
            return false
        }

        // Allow only letters and optionally some other characters
        let allowedCharacterSet = CharacterSet.letters
        let nameCharacterSet = CharacterSet(charactersIn: firstName)

        if !allowedCharacterSet.isSuperset(of: nameCharacterSet) {
            return false
        }

        return true
    }
    
    func isValidLastName(lastName: String) -> Bool {
        // Similar basic checks as first name
        guard !lastName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              lastName.count <= 50 else { // Adjust max length as needed
            return false
        }

        // Allow only letters and optionally some other characters
        let allowedCharacterSet = CharacterSet.letters
        let nameCharacterSet = CharacterSet(charactersIn: lastName)

        if !allowedCharacterSet.isSuperset(of: nameCharacterSet) {
            return false
        }

        return true
    }
    
    private func showErrorMessage(_ message: String) {
        // Replace this with your error display logic (e.g., UIAlertController)
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        if btnContinue.alpha == 1.0 {
            guard let firstName = txtFirstName.text, isValidFirstName(firstName: firstName) else {
                showErrorMessage("Please enter a valid first name.")
                return
            }
            
            guard let lastName = txtLastName.text, isValidLastName(lastName: lastName) else {
                showErrorMessage("Please enter a valid last name.")
                return
            }
            
            UserProfileData.shared.setFirstName(firstName: firstName)
            UserProfileData.shared.setLastName(lastName: lastName)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let termsAndConditionsViewController = storyboard.instantiateViewController(withIdentifier: "TermsAndConditionsViewController") as! TermsAndConditionsViewController
            self.navigationController?.pushViewController(termsAndConditionsViewController, animated: true)
        }
    }
    
    @IBAction func backButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension EnterNameViewController: UITextFieldDelegate {
    
    //Text Input On Focus
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
        if textField == txtFirstName || textField == txtLastName {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor(hex: "#D2D2D2")?.cgColor
            textField.backgroundColor = .clear
        }
    }
    
    //TextInput Focus Gone
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtFirstName || textField == txtLastName {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.backgroundColor = UIColor(hex: "E1E1E1")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtFirstName {
            let currentFirstName = textField.text ?? "" //Current text
            guard let stringRange = Range(range, in: currentFirstName) else { return true }
            let updatedText = currentFirstName.replacingCharacters(in: stringRange, with: string)
            
            //Continue Button - State
            if updatedText.isEmpty || (txtLastName.text ?? "").isEmpty {
                btnContinue.alpha = 0.4
            } else {
                btnContinue.alpha = 1.0
            }
        }
        
        if textField == txtLastName {
            let currentLastName = textField.text ?? "" //Current text
            guard let stringRange = Range(range, in: currentLastName) else { return true }
            let updatedText = currentLastName.replacingCharacters(in: stringRange, with: string)
            
            //Continue Button - State
            if updatedText.isEmpty || (txtFirstName.text ?? "").isEmpty {
                btnContinue.alpha = 0.4
            } else {
                btnContinue.alpha = 1.0
            }
        }
        
        return true
    }
    
}
