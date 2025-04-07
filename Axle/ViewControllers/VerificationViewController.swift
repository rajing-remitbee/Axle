//
//  VerificationViewController.swift
//  Axle
//
//  Created by Rajin Gangadharan on 02/04/25.
//

import UIKit

class VerificationViewController: UIViewController {
    
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var txtHead: UILabel!
    
    @IBOutlet weak var txtOtp1: UITextField!
    @IBOutlet weak var txtOtp2: UITextField!
    @IBOutlet weak var txtOtp3: UITextField!
    @IBOutlet weak var txtOtp4: UITextField!
    
    @IBOutlet weak var btnContinue: UIButton!
    
    var phoneNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtOtp1.delegate = self
        txtOtp2.delegate = self
        txtOtp3.delegate = self
        txtOtp4.delegate = self
        
        txtOtp1.becomeFirstResponder()
        
        btnContinue.isEnabled = false
        btnContinue.alpha = 0.4
        
        navigationItem.hidesBackButton = true
        txtHead.text = "Enter the 4 digit code sent to you at \(phoneNumber)"
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnContinuePressed(_ sender: UIButton) {
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let verificationViewController = storyboard.instantiateViewController(withIdentifier: "EmailAddressViewController") as! EmailAddressViewController
//        self.navigationController?.pushViewController(verificationViewController, animated: true)
    }
}

extension VerificationViewController: UITextFieldDelegate {
    
    //Text Input On Focus
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
        if textField == txtOtp1 || textField == txtOtp2 || textField == txtOtp3 || textField == txtOtp4 {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor(hex: "#D2D2D2")?.cgColor
            textField.backgroundColor = .clear
        }
    }
    
    //TextInput Focus Gone
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtOtp1 || textField == txtOtp2 || textField == txtOtp3 || textField == txtOtp4 {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.backgroundColor = UIColor(hex: "E1E1E1")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let allowedCharacters = CharacterSet.decimalDigits
        let characterSet = CharacterSet(charactersIn: string)
        if !allowedCharacters.isSuperset(of: characterSet) { return false }
        
        // Handle backspace and forward navigation
        if string.isEmpty {
            if textField.text?.count == 1 {
                textField.text = ""
                switch textField {
                case txtOtp2:
                    txtOtp1.becomeFirstResponder()
                case txtOtp3:
                    txtOtp2.becomeFirstResponder()
                case txtOtp4:
                    txtOtp3.becomeFirstResponder()
                default:
                    break
                }
            }
        } else {
            textField.text = string
            switch textField {
            case txtOtp1:
                txtOtp2.becomeFirstResponder()
            case txtOtp2:
                txtOtp3.becomeFirstResponder()
            case txtOtp3:
                txtOtp4.becomeFirstResponder()
            case txtOtp4:
                txtOtp4.resignFirstResponder()
            default:
                break
            }
        }
        
        let otp = "\(txtOtp1.text ?? "")\(txtOtp2.text ?? "")\(txtOtp3.text ?? "")\(txtOtp4.text ?? "")"
        btnContinue.isEnabled = otp.count == 4
        btnContinue.alpha = otp.count == 4 ? 1.0 : 0.5
        
        return false
    }
}
