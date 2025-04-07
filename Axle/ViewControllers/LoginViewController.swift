//
//  LoginViewController.swift
//  Axle
//
//  Created by Rajin Gangadharan on 28/03/25.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var countryPickerInputView: CountryPickerInputView! //Country Picker
    @IBOutlet weak var phoneNumberTextView: UITextField! //Phone Number Input
    
    @IBOutlet weak var btnContinue: UIButton! //Continue button
    @IBOutlet weak var btnApple: UIButton! //Continue with Apple
    @IBOutlet weak var btnGoogle: UIButton! //Continue with Google
    @IBOutlet weak var btnEmail: UIButton! //Continue with Email
    
    var initialData: [CountryCode] = []
    var countries: [Country] = [] //Countries List
    private var filteredCountries: [Country] = [] //Filtered List
    private var isDropdownVisible = false //Dropdown Visible
    private let dropdownTableView = UITableView() //Dropdown Table
    private var dropdownHeightConstraint: NSLayoutConstraint? //DropDown Height Constraint
    private var dropdownTopConstraint: NSLayoutConstraint? //Dropdown Top Constraint
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true //Hide Navigation Button
        
        //Button Corners
        btnContinue.layer.cornerRadius = 10
        btnApple.layer.cornerRadius = 10
        btnGoogle.layer.cornerRadius = 10
        btnEmail.layer.cornerRadius = 10
        
        loadCountries() //Countries List
        filteredCountries = countries //Filtered Countries
        
        countryPickerInputView.delegate = self //Country Picker Delegate
        phoneNumberTextView.delegate = self //Phone Number Text Input
        
        let defaultCountry = countries.first { $0.code == Locale.current.region?.identifier } ?? countries.first { $0.code == "IN" } //Default Country
        
        //Continue Button - State
        let isPhoneNumberEmpty = phoneNumberTextView.text?.isEmpty ?? true
        btnContinue.alpha = isPhoneNumberEmpty ? 0.4 : 1.0
        
        //Set Default Country
        if let defaultCountry = defaultCountry {
            countryPickerInputView.selectedCountry = defaultCountry
            updatePhoneNumberPrefix(country: defaultCountry)
        }
        
        //Setup DropDown Table
        setupDropdownTableView()
        
        //Setup Dismiss Gesture
        setupDismissTapGesture()
    }
    
    //Continue Button Pressed
    @IBAction func btnContinuePressed(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let verificationViewController = storyboard.instantiateViewController(withIdentifier: "VerificationViewController") as! VerificationViewController
        
        if let phone = phoneNumberTextView.text {
            if let prefixText = getPrefixText() {
                verificationViewController.phoneNumber = "\(prefixText)\(phone)"
            } else {
                print("No prefix found.")
            }
        } else {
            verificationViewController.phoneNumber = ""
        }
        self.navigationController?.pushViewController(verificationViewController, animated: true)
    }
    
    func getPrefixText() -> String? {
        guard let leftView = phoneNumberTextView.leftView else {
            return ""
        }

        for subview in leftView.subviews {
            if let prefixLabel = subview as? UILabel {
                return prefixLabel.text
            }
        }
        return ""
    }
    
    //Countries List - Sorted
    private func loadCountries() {
        countries = []
        initialData.forEach { country in
            countries += [Country(code: country.countrycode, name: country.name, phoneCode: country.dialcode)]
        }
        countries = countries.sorted { $0.name < $1.name }
    }
    
    //Dropdown - Setup
    private func setupDropdownTableView() {
        //Dropdown Table Setup
        dropdownTableView.translatesAutoresizingMaskIntoConstraints = false
        dropdownTableView.dataSource = self
        dropdownTableView.delegate = self
        dropdownTableView.register(CountryTableViewCell.self, forCellReuseIdentifier: "CountryCell")
        dropdownTableView.isHidden = true
        dropdownTableView.layer.cornerRadius = 20
        dropdownTableView.backgroundColor = .white
        dropdownTableView.layer.masksToBounds = true
        
        view.addSubview(dropdownTableView)
        
        //Constraints
        dropdownTopConstraint = dropdownTableView.topAnchor.constraint(equalTo: countryPickerInputView.bottomAnchor, constant: 8)
        dropdownHeightConstraint = dropdownTableView.heightAnchor.constraint(equalToConstant: 0)
        let dropdownLeadingConstraint = dropdownTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
        let dropdownTrailingConstraint = dropdownTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        
        NSLayoutConstraint.activate([
            dropdownTopConstraint!,
            dropdownLeadingConstraint,
            dropdownTrailingConstraint,
            dropdownHeightConstraint!
        ])
    }
    
    //Update Phone Number Prefix
    private func updatePhoneNumberPrefix(country: Country) {
        //Prefix
        let prefixLabel = UILabel()
        prefixLabel.text = "\(country.phoneCode) "
        prefixLabel.font = phoneNumberTextView.font
        prefixLabel.sizeToFit()
        prefixLabel.textColor = .black
        
        //Padding
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: 16 + prefixLabel.frame.width, height: prefixLabel.frame.height)
        prefixLabel.frame.origin = CGPoint(x: 16, y: 0)
        
        containerView.addSubview(prefixLabel)
        
        phoneNumberTextView.leftView = containerView
        phoneNumberTextView.leftViewMode = .always
    }
    
    //Show Dropdown
    private func showDropdown(show: Bool) {
        guard isDropdownVisible != show else { return }
        
        isDropdownVisible = show
        dropdownTableView.isHidden = false
        
        countryPickerInputView.isDropdownOpen = show
        
        view.layoutIfNeeded()
        
        //Animate
        UIView.animate(withDuration: 0.3, animations: {
            let targetHeight: CGFloat = show ? min(CGFloat(self.filteredCountries.count * 50), 250) : 0
            self.dropdownHeightConstraint?.constant = targetHeight
            self.dropdownTableView.alpha = show ? 1.0 : 0.0
            self.view.layoutIfNeeded()
        }) { (_) in
            if !show {
                self.dropdownTableView.isHidden = true
                self.dropdownTableView.setContentOffset(.zero, animated: false)
                self.filteredCountries = self.countries
                self.dropdownTableView.reloadData()
            } else {
                self.dropdownTableView.flashScrollIndicators()
            }
        }
    }
    
    //Setup Dismiss Gesture
    private func setupDismissTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBackgroundTap(_:)))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    //Handle Tap Gesture
    @objc private func handleBackgroundTap(_ gesture: UITapGestureRecognizer) {
        if isDropdownVisible {
            let tapLocation = gesture.location(in: self.view)
            if !dropdownTableView.frame.contains(tapLocation) && !countryPickerInputView.frame.contains(tapLocation) {
                showDropdown(show: false)
            }
        }
    }
    
}

extension LoginViewController: CountryPickerInputViewDelegate {
    func countryPickerInputView(_ view: CountryPickerInputView, didSelect country: Country) {
        updatePhoneNumberPrefix(country: country)
    }
    
    func countryPickerInputViewDidTapToExpand(_ view: CountryPickerInputView) {
        showDropdown(show: !isDropdownVisible)
    }
}

extension LoginViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryCell", for: indexPath) as? CountryTableViewCell else {
            return UITableViewCell()
        }
        let country = filteredCountries[indexPath.row]
        cell.configure(with: country)
        return cell
    }
}

extension LoginViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCountry = filteredCountries[indexPath.row]
        
        countryPickerInputView.countrySelected(selectedCountry)
        
        updatePhoneNumberPrefix(country: selectedCountry)
        
//         self.delegate?.didSelectCountry(selectedCountry)
        showDropdown(show: false)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}

extension LoginViewController: UITextFieldDelegate {
    
    //Text Input On Focus
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == phoneNumberTextView {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor(hex: "#D2D2D2")?.cgColor
            textField.backgroundColor = .clear
        }
    }
    
    //TextInput Focus Gone
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == phoneNumberTextView {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.backgroundColor = UIColor(hex: "E1E1E1")
        }
    }
    
    // Text Field Changes
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == phoneNumberTextView {
            let currentText = textField.text ?? "" //Current text
            guard let stringRange = Range(range, in: currentText) else { return true }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            btnContinue.alpha = updatedText.isEmpty ? 0.4 : 1.0 //Update Continue button
            btnContinue.isEnabled =  updatedText.isEmpty ? false : true
        }
        return true
    }
    
}
