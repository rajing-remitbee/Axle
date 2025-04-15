//
//  AddressInfoViewController.swift
//  Axle
//
//  Created by Rajin Gangadharan on 01/04/25.
//

import UIKit
import MapKit

class AddressInfoViewController: UIViewController {

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var address1: UITextField!
    @IBOutlet weak var address2: UITextField!
    @IBOutlet weak var addressLabel: UITextField!
    @IBOutlet weak var txtLocation: UILabel!
    
    @IBOutlet weak var btnMeetAtDoor: UIButton!
    @IBOutlet weak var btnLeaveAtDoor: UIButton!
    @IBOutlet weak var btnSaveAddress: UIButton!
    
    private var deliveryOption = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtLocation.text = UserProfileData.shared.getCurrentLocation()
        
        roundedView.layer.cornerRadius = 20
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        address1.setupPadding(left: 16)
        address2.setupPadding(left: 16)
        addressLabel.setPadding(left: 16)
        
        address1.delegate = self
        address2.delegate = self
        addressLabel.delegate = self
        
        btnSaveAddress.alpha = 0.4
        
        btnLeaveAtDoor.layer.borderWidth = 1
        btnLeaveAtDoor.layer.borderColor = UIColor(hex: "#06C169")?.cgColor
        btnMeetAtDoor.layer.borderWidth = 0
        deliveryOption = 1
        
        mapView.delegate = self
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(UserProfileData.shared.getCurrentLocation()) { (placemarks, error) in
            if let placemark = placemarks?.first {
                if let coordinate = placemark.location?.coordinate {
                    let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }
    }
    
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func btnSaveAddressTapped(_ sender: UIButton) {
        if btnSaveAddress.alpha == 1.0 {
            
            UserProfileData.shared.setAptName(aptName: address1.text ?? "")
            UserProfileData.shared.setBuildingName(buildName: address2.text ?? "")
            if deliveryOption == 1 {
                UserProfileData.shared.setPickupType(pickupType: "Leave at Door")
            } else {
                UserProfileData.shared.setPickupType(pickupType: "Meet at Door")
            }
            UserProfileData.shared.setPickupLabel(label: addressLabel.text ?? "")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let pushNotificationViewController = storyboard.instantiateViewController(withIdentifier: "PushNotificationViewController") as! PushNotificationViewController
            pushNotificationViewController.modalPresentationStyle = .fullScreen
            present(pushNotificationViewController, animated: true)
        }
    }
    
    @IBAction func btnLeaveAtDDoorTapped(_ sender: UIButton) {
        btnLeaveAtDoor.layer.borderWidth = 1
        btnLeaveAtDoor.layer.borderColor = UIColor(hex: "#06C169")?.cgColor
        btnMeetAtDoor.layer.borderWidth = 0
        deliveryOption = 1
    }
    
    @IBAction func btnMeetAtDoorTapped(_ sender: UIButton) {
        btnMeetAtDoor.layer.borderWidth = 1
        btnMeetAtDoor.layer.borderColor = UIColor(hex: "#06C169")?.cgColor
        btnLeaveAtDoor.layer.borderWidth = 0
        deliveryOption = 2
    }
}

extension AddressInfoViewController: MKMapViewDelegate {
    
}

extension AddressInfoViewController: UITextFieldDelegate {
    
    //Text Input On Focus
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAll(nil)
        if textField == address1 || textField == address2 || textField == addressLabel {
            textField.layer.borderWidth = 1
            textField.layer.borderColor = UIColor(hex: "#D2D2D2")?.cgColor
            textField.backgroundColor = .clear
        }
    }
    
    //TextInput Focus Gone
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == address1 || textField == address2 || textField == addressLabel {
            textField.layer.borderWidth = 0
            textField.layer.borderColor = UIColor.clear.cgColor
            textField.backgroundColor = UIColor(hex: "E1E1E1")
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == address1 {
            let currentText = textField.text ?? "" //Current text
            guard let stringRange = Range(range, in: currentText) else { return true }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            //Continue Button - State
            if updatedText.isEmpty || (address2.text ?? "").isEmpty || (addressLabel.text ?? "").isEmpty {
                btnSaveAddress.alpha = 0.4
            } else {
                btnSaveAddress.alpha = 1.0
            }
        }
        
        if textField == address2 {
            let currentText = textField.text ?? "" //Current text
            guard let stringRange = Range(range, in: currentText) else { return true }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            //Continue Button - State
            if updatedText.isEmpty || (address1.text ?? "").isEmpty || (addressLabel.text ?? "").isEmpty {
                btnSaveAddress.alpha = 0.4
            } else {
                btnSaveAddress.alpha = 1.0
            }
        }
        
        if textField == addressLabel {
            let currentText = textField.text ?? "" //Current text
            guard let stringRange = Range(range, in: currentText) else { return true }
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            //Continue Button - State
            if updatedText.isEmpty || (address1.text ?? "").isEmpty || (address2.text ?? "").isEmpty {
                btnSaveAddress.alpha = 0.4
            } else {
                btnSaveAddress.alpha = 1.0
            }
        }
        return true
    }
    
}

extension UITextField {
    
    func addPadding(padding: UIEdgeInsets) {
        let paddingView = UIView(frame: CGRect.zero)
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setPadding(left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil){
        let padding = UIEdgeInsets.init(top: top ?? 0, left: left ?? 0, bottom: bottom ?? 0, right: right ?? 0)
        self.leftView = UIView(frame: CGRect.init(x: 0, y: 0, width: padding.left, height: 0))
        self.leftViewMode = .always
        self.rightView = UIView(frame: CGRect.init(x: 0, y: 0, width: padding.right, height: 0))
        self.rightViewMode = .always
    }
    
    func setBothPadding(padding: CGFloat){
        self.setPadding(left: padding, right: padding)
    }
    
}
