//
//  PushNotificationViewController.swift
//  Axle
//
//  Created by Rajin Gangadharan on 01/04/25.
//

import UIKit

class PushNotificationViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        activityIndicator.isHidden = true
    }
    
    //Request Notification Permission
    private func requestNotificationPermission() {
        self.showLoadingIndicator()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                // Permission granted
                DispatchQueue.main.async {
                    self.showToast(message: "Permission Granted!")
                    self.updateAddress()
                }
            } else if let error = error {
                // Handle error
                DispatchQueue.main.async {
                    self.showToast(message: "Failed to request permission!")
                    self.showMessage("Failed to request notification permission. \(error)")
                }
            } else {
                //Permission Denied
                DispatchQueue.main.async {
                    self.showToast(message: "Notification Permission Denied!")
                }
            }
        }
    }
    
    //Add Address
    private func updateAddress() {
        self.showLoadingIndicator()
        let userId = UserProfileData.shared.getUserId()
        let aptname = UserProfileData.shared.getAptName()
        let buildName = UserProfileData.shared.getBuildingName()
        let pickupType = UserProfileData.shared.getPickupType()
        let label = UserProfileData.shared.getPickupLabel()
        
        let query = "mutation { createUserAddress(user_id: \(userId), apt_suite_floor: \"\(aptname)\", business_building_name: \"\(buildName)\" delivery_option: \"\(pickupType)\", label: \"\(label)\", latitude: \(UserProfileData.shared.getCurrentLatitude()), longitude: \(UserProfileData.shared.getCurrentLongitude()), address_line1: \"\", address_line2: \"\", city: \"\", state: \"\", postal_code: \"\", country: \"\", is_default: true) { user_id label latitude longitude } }"
        
        BackendService.shared.performGraphQLRequest(query: query) { [weak self] (result: Result<CreateAddressResponse, Error>) in
            DispatchQueue.main.async() {
                self?.hideLoadingIndicator()
                switch result {
                case .success(let response):
                    print("Address Created Successfully!")
                    self?.navigateToSignUpSuccessScreen()
                    
                case .failure(let error):
                    print("Error: \(error)")
                    self?.showErrorMessage("Cannot perform your request!")
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
    
    //Navigate to SgnupSuccess Screen
    private func navigateToSignUpSuccessScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signupSuccessViewController = storyboard.instantiateViewController(withIdentifier: "SignUpSuccessViewController") as! SignUpSuccessViewController
        signupSuccessViewController.modalPresentationStyle = .fullScreen
        present(signupSuccessViewController, animated: true)
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
    
    //Show Alert Message
    private func showMessage(_ message: String) {
        //Alert dialog
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    //Push Notifications Button Pressed
    @IBAction func btnPushNotificationPressed(_ sender: UIButton) {
        requestNotificationPermission()
    }
    
    //Skip button pressed
    @IBAction func btnSkipNotificationPressed(_ sender: UIButton) {
        updateAddress()
    }
}
