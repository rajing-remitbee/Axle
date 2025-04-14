//
//  PushNotificationViewController.swift
//  Axle
//
//  Created by Rajin Gangadharan on 01/04/25.
//

import UIKit

class PushNotificationViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Request Notification Permission
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                // Permission granted
                DispatchQueue.main.async {
                    self.showToast(message: "Permission Granted!")
                    self.navigateToSignUpSuccessScreen()
                }
            } else if let error = error {
                // Handle error
                DispatchQueue.main.async {
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
    
    //Navigate to SgnupSuccess Screen
    private func navigateToSignUpSuccessScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signupSuccessViewController = storyboard.instantiateViewController(withIdentifier: "SignUpSuccessViewController") as! SignUpSuccessViewController
        self.navigationController?.popToRootViewController(animated: true)
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
        navigateToSignUpSuccessScreen()
    }
}
