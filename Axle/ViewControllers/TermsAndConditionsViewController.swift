//
//  TermsAndConditionsViewController.swift
//  Axle
//
//  Created by Rajin Gangadharan on 01/04/25.
//

import UIKit

class TermsAndConditionsViewController: UIViewController {
    
    @IBOutlet weak var btnAgree: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
    }
    
    private func createUser() {
        
        self.showLoadingIndicator()
        
        let query = "mutation { createUser(phone_number: \"\(UserProfileData.shared.getMobileNumber())\", email: \"\(UserProfileData.shared.getEmailAddress())\", first_name: \"\(UserProfileData.shared.getFirstName())\", last_name: \"\(UserProfileData.shared.getLastName())\", terms_accepted: true, location_access_granted: false, push_notifications_enabled: false) { id phone_number } }"
        
        BackendService.shared.performGraphQLRequest(query: query) { [weak self] (result: Result<CreateUserResponse, Error>) in
            DispatchQueue.main.async() {
                self?.hideLoadingIndicator()
                switch result {
                case .success(let response):
                    print("User created successfully!")
                    UserProfileData.shared.setUserId(userId: response.createUser.id)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let LocationAccessView = storyboard.instantiateViewController(withIdentifier: "LocationAccessViewController") as! LocationAccessViewController
                    self?.navigationController?.pushViewController(LocationAccessView, animated: true)
                    
                case .failure(let error):
                    print("Error generating OTP: \(error)")
                    self?.showErrorMessage("Request cannot be fulfilled!")
                }
            }
        }
        
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
    
    @IBAction func btnAgreePressed(_ sender: UIButton) {
        
        UserProfileData.shared.setTermsAndConditions(choice: true)
        
        createUser()
    
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
