//
//  LocationInfoViewController.swift
//  Axle
//
//  Created by Rajin Gangadharan on 02/04/25.
//

import UIKit

class LocationInfoViewController: UIViewController {

    @IBOutlet weak var roundedView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundedView.layer.cornerRadius = 20
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        
    }

}
