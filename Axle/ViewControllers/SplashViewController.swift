//
//  SplashViewController.swift
//  Axle
//
//  Created by Rajin Gangadharan on 27/03/25.
//

import UIKit

class SplashViewController: UIViewController {
    
    private var countryCodes: [CountryCode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchConfigs() //Fetch configs
    }
    
    //Fetch Configs
    private func fetchConfigs() {
        //Fetch GraphQL URL from Remote Config
        BackendService.shared.fetchGraphQLURL { [weak self] fetchedURL in
            self?.checkBackendConnection()
        }
    }
    
    //Check if backend works
    func checkBackendConnection() {
        //Hit request to the backend
        BackendService.shared.checkBackendStatus { [weak self] isBackendOK in
            DispatchQueue.main.async {
                if isBackendOK {
                    //Show success toast
                    self?.showToast(message: "Connection Successful!")
                    self?.downloadCountryCodes()
                } else {
                    //Show error toast
                    self?.showToast(message: "Sorry, Connection Failed!")
                    self?.showBackendConnectionError()
                }
            }
        }
    }
    
    //Download Country Codes
    func downloadCountryCodes() {
        BackendService.shared.performGraphQLRequest(query: "query { countryCodes { id name dialcode countrycode } }") { [weak self] (result: Result<CountryCodesResponse, Error>) in
            DispatchQueue.main.async { // Update UI on the main thread
                switch result {
                case .success(let response):
                    print("Successfully downloaded country codes.")
                    self?.countryCodes = response.countryCodes
                    self?.navigateToLoginScreen()
                case .failure(let error):
                    print("Error downloading country codes: \(error)")
                    // Handle the error appropriately, perhaps show an alert or retry
                    self?.showDownloadErrorAndCloseApp() // Or handle differently
                }
            }
        }
    }
    
    //Show Backend Connection Error
    func showBackendConnectionError() {
        //Alert Controller
        let alert = UIAlertController(title: "Connection Error", message: "Unable to connect to the backend. Please try again later.", preferredStyle: .alert)
        //Alert Button
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            exit(0)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
    
    //Navigate to Login Screen
    private func navigateToLoginScreen() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            loginViewController.initialData = self.countryCodes
            self.navigationController?.pushViewController(loginViewController, animated: true) //Push login screen
            self.navigationController?.viewControllers.remove(at: 0) //Remove splash screen
        }
    }
    
    func showDownloadErrorAndCloseApp() {
        //Alert Controller
        let alert = UIAlertController(title: "Download Error", message: "Unable to download necessary data. The app will now close. Please try again later.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { _ in
            // Close the app programmatically
            exit(0)
        }
        alert.addAction(okAction)
        self.present(alert, animated: true)
    }
}
