//
//  LocationAccessViewController.swift
//  Axle
//
//  Created by Rajin Gangadharan on 01/04/25.
//

import UIKit
import CoreLocation

class LocationAccessViewController: UIViewController {

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnLocationAllow: UIButton!
    @IBOutlet weak var btnCancel: UIButton!
    
    private let locationManager = CLLocationManager() //CL - Location Manager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self //LocationManager Delegate

        navigationItem.hidesBackButton = true //Hide Back Button
        btnCancel.layer.borderWidth = 1 //Cancel button border width
        btnCancel.layer.borderColor = UIColor(hex: "#06C169")?.cgColor //Cancel button border color
    }
    
    private func requestLocationPermissionAndFetchLocation() {
        let status = locationManager.authorizationStatus //Location Permission Status
        
        switch status {
            //Not Determined
        case .notDetermined:
            //Request for Location Permission
            locationManager.requestWhenInUseAuthorization()
            //Denied or Restricted
        case .restricted, .denied:
            // Show an alert for granting permission
            showLocationServicesDeniedAlert()
            //Authorized
        case .authorizedAlways, .authorizedWhenInUse:
            // Permission granted, Fetch the location
            fetchCurrentLocation()
        @unknown default:
            self.showToast(message: "Unhandled location status")
        }
    }
    
    private func showLocationServicesDeniedAlert() {
        //Show alert message
        let alert = UIAlertController(title: "Location Permission Required", message: "Please enable location services in Settings to use this feature.", preferredStyle: .alert)
        //Settings Action Button
        let settingsAction = UIAlertAction(title: "Settings", style: .default) { _ in
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            
            //Open settings app
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl)
            }
        }
        
        alert.addAction(settingsAction)
        //Cancel button
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func fetchCurrentLocation() {
        // Start updating location
        locationManager.startUpdatingLocation()
    }
    
    private func processLocation(_ location: CLLocation) {
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                return
            }
            
            if let placemark = placemarks?.first {
                // Extract address components
                let address = self.formatAddress(from: placemark)
                UserProfileData.shared.setCurrentLatitude(latitude: "\(latitude)")
                UserProfileData.shared.setCurrentLongitude(longitude: "\(longitude)")
                UserProfileData.shared.setCurrentLocation(location: address)
                self.navigateToLocationInfoViewScreen()
            }
        }
    }
    
    private func formatAddress(from placemark: CLPlacemark) -> String {
        var components: [String] = []
        
        if let name = placemark.name {
            components.append(name)
        }
        if let locality = placemark.locality {
            components.append(locality)
        }
        if let administrativeArea = placemark.administrativeArea {
            components.append(administrativeArea)
        }
        if let postalCode = placemark.postalCode {
            components.append(postalCode)
        }
        if let country = placemark.country {
            components.append(country)
        }
        
        return components.joined(separator: ", ")
    }
    
    //Navigate to LocationInfoView Screen
    private func navigateToLocationInfoViewScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let locationInfoViewController = storyboard.instantiateViewController(withIdentifier: "LocationInfoViewController") as! LocationInfoViewController
        
        if let sheet = locationInfoViewController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = false
        }
        
        present(locationInfoViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func btnLocationAllowPressed(_ sender: UIButton) {
        requestLocationPermissionAndFetchLocation()
    }
    
    @IBAction func btnLocationCancelPressed(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

extension LocationAccessViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            // Permission granted, proceed
            fetchCurrentLocation()
        case .restricted, .denied:
            // Permission denied, handle accordingly
            print("Location permission denied.")
            showLocationServicesDeniedAlert()
        case .notDetermined:
            // This case should be handled in requestLocationPermission(), so we don't need to do anything here.
            break
        @unknown default:
            print("Unhandled authorization status")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Handle updated location data here
        if let location = locations.last {
            processLocation(location)
            // Stop updating location if you only need one update
            locationManager.stopUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle location update errors
        print("Location update error: \(error.localizedDescription)")
    }
    
}
