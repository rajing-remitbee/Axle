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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundedView.layer.cornerRadius = 20
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        address1.setupPadding(left: 16)
        address2.setupPadding(left: 16)
        addressLabel.setPadding(left: 16)
        
        mapView.delegate = self
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString("239 Greene St, New York, NY 10003") { (placemarks, error) in
            if let placemark = placemarks?.first {
                if let coordinate = placemark.location?.coordinate {
                    let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 10000, longitudinalMeters: 10000)
                    self.mapView.setRegion(region, animated: true)
                }
            }
        }
    }
}

extension AddressInfoViewController: MKMapViewDelegate {
    
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
