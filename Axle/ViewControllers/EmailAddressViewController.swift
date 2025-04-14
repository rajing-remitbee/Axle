//
//  EmailAddressViewController.swift
//  Axle
//
//  Created by Rajin Gangadharan on 10/04/25.
//

import UIKit

class EmailAddressViewController: UIViewController {
    
    @IBOutlet weak var txtEmailAddress: UITextField!
    @IBOutlet weak var btnContinue: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        btnContinue.alpha = 0.4
        txtEmailAddress.setPadding(left: 16, right: 16)
        txtEmailAddress.delegate = self
    }
    
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Z0-9a-z.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func showErrorMessage(_ message: String) {
        // Replace this with your error display logic (e.g., UIAlertController)
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func continueButtonPressed(_ sender: UIButton) {
        if btnContinue.alpha == 1.0 {
            guard let email = txtEmailAddress.text, isValidEmail(email: email) else {
                showErrorMessage("Please enter a valid email address.")
                return
            }
            
            UserProfileData.shared.setEmailAddress(emailAddress: email)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let enterNameViewController = storyboard.instantiateViewController(withIdentifier: "EnterNameViewController") as! EnterNameViewController
            self.navigationController?.pushViewController(enterNameViewController, animated: true)
        }
    }
}

extension EmailAddressViewController: UITextFieldDelegate {
    
    //Text Input On Focus
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
        if textField == txtEmailAddress {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor(hex: "#D2D2D2")?.cgColor
            textField.backgroundColor = .clear
        }
    }
    
    //TextInput Focus Gone
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtEmailAddress {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.backgroundColor = UIColor(hex: "E1E1E1")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtEmailAddress {
            let currentText = textField.text ?? "" //Current text
            guard let stringRange = Range(range, in: currentText) else { return true }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            //Continue Button - State
            if updatedText.isEmpty {
                btnContinue.alpha = 0.4
            } else {
                btnContinue.alpha = 1.0
            }
        }
        return true
    }
    
}
