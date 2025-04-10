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
    
    @IBOutlet weak var btnResend: UIButton!
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var txtTime: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var phoneNumber = ""
    private var generatedToken: String?
    private var generatedOTP: String?
    
    private var resendTimer: Timer?
    private var remainingTime: Int = 60
    private var isResendButtonEnabled: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.startAnimating()
        
        txtOtp1.delegate = self
        txtOtp2.delegate = self
        txtOtp3.delegate = self
        txtOtp4.delegate = self
        
        txtOtp1.becomeFirstResponder()
        
        btnContinue.alpha = 0.4
        btnResend.alpha = 1.0
        
        txtTime.isHidden = true
        
        navigationItem.hidesBackButton = true
        txtHead.text = "Enter the 4 digit code sent to you at \(phoneNumber)"
        
        activityIndicator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        activityIndicator.isHidden = true
        
        generateAndSendOTP()
    }
    
    private func generateAndSendOTP() {
        self.showLoadingIndicator()
        
        txtOtp1.text = ""
        txtOtp2.text = ""
        txtOtp3.text = ""
        txtOtp4.text = ""
        
        let query = "mutation { generateOTP(phone_number: \"\(phoneNumber)\") { otp token } }"
        BackendService.shared.performGraphQLRequest(query: query) { [weak self] (result: Result<GenerateOTPResponse, Error>) in
            DispatchQueue.main.async() {
                self?.hideLoadingIndicator()
                switch result {
                case .success(let response):
                    print("OTP generated successfully!")
                    self?.generatedToken = response.generateOTP.token
                    self?.generatedOTP = response.generateOTP.otp
                    self?.populateOTPTextFields(otp: response.generateOTP.otp)
                    
                case .failure(let error):
                    print("Error generating OTP: \(error)")
                    self?.showDownloadErrorAndCloseApp()
                }
            }
        }
    }
    
    private func verifyOTP() {
        guard let token = generatedToken else {
            return
        }
        let enteredOTP = "\(txtOtp1.text ?? "")\(txtOtp2.text ?? "")\(txtOtp3.text ?? "")\(txtOtp4.text ?? "")"
        let query = "mutation { verifyOTP(phone_number: \"\(phoneNumber)\", otp: \"\(enteredOTP)\", token: \"\(token)\") { success message } }"
        
        activityIndicator.startAnimating() // Show loading during verification
        
        BackendService.shared.performGraphQLRequest(query: query) { [weak self] (result: Result<VerifyOTPResponse, Error>) in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating() // Hide loading
                switch result {
                case .success(let response):
                    if response.verifyOTP.success {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let emailaddressViewController = storyboard.instantiateViewController(withIdentifier: "EmailAddressViewController") as! EmailAddressViewController
                        var currentStack = self?.navigationController?.viewControllers ?? []
                        if !currentStack.isEmpty {
                            currentStack.removeLast() // Remove the last one (self)
                        }
                        currentStack.append(emailaddressViewController)
                        self?.navigationController?.setViewControllers(currentStack, animated: true)
                    } else {
                        self?.showErrorMessage(response.verifyOTP.message)
                    }
                case .failure(let error):
                    print("Error verifying OTP: \(error)")
                    self?.showErrorMessage("Failed to verify OTP. Please try again.")
                }
            }
        }
    }
    
    private func populateOTPTextFields(otp: String) {
        guard otp.count == 4 else {
            print("Invalid OTP length: \(otp.count)")
            return
        }
        let otpDigits = Array(otp)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.txtOtp1.text = String(otpDigits[0])
            self.txtOtp2.text = String(otpDigits[1])
            self.txtOtp3.text = String(otpDigits[2])
            self.txtOtp4.text = String(otpDigits[3])
        }) { _ in
            if self.txtOtp4.text?.isEmpty == false {
                self.btnContinue.alpha = 1.0
            }
        }
    }
    
    private func startResendTimer() {
        isResendButtonEnabled = false
        btnResend.alpha = 0.4
        txtTime.isHidden = false
        remainingTime = 60
        updateCountdownLabel()
        resendTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerTick), userInfo: nil, repeats: true)
    }
    
    private func updateCountdownLabel() {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        txtTime.text = String(format: "Resend in %02d:%02d", minutes, seconds)
    }
    
    private func stopResendTimer() {
        resendTimer?.invalidate()
        resendTimer = nil
        isResendButtonEnabled = true
        btnResend.alpha = 1.0
        txtTime.isHidden = true
    }
    
    @objc private func timerTick() {
        remainingTime -= 1
        updateCountdownLabel()

        if remainingTime <= 0 {
            stopResendTimer()
        }
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnResendPressed(_ sender: UIButton) {
        if isResendButtonEnabled {
            generateAndSendOTP()
            startResendTimer()
        }
    }
    
    
    @IBAction func btnContinuePressed(_ sender: UIButton) {
        if(btnContinue.alpha == 1.0) {
            verifyOTP()
        }
    }
    
    func showDownloadErrorAndCloseApp() {
        //Alert Controller
        let alert = UIAlertController(title: "Error!", message: "Unable to generate OTP! Please try after sometime", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    private func showErrorMessage(_ message: String) {
        // Replace this with your error display logic (e.g., UIAlertController)
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    //Show Activity Indicator
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false //Show the activity indicator
        activityIndicator.startAnimating() //Start animation
    }
    
    //Hide Activity Indicator
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true //Hide the activity indicator
        activityIndicator.stopAnimating() //Stop the animation
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
        btnContinue.alpha = otp.count == 4 ? 1.0 : 0.5
        
        return false
    }
}
