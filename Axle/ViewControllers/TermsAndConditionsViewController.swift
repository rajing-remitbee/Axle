//
//  TermsAndConditionsViewController.swift
//  Axle
//
//  Created by Rajin Gangadharan on 01/04/25.
//

import UIKit

class TermsAndConditionsViewController: UIViewController {
    
    @IBOutlet weak var btnAgree: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
    }
    
    @IBAction func btnAgreePressed(_ sender: UIButton) {
        
        UserProfileData.shared.setTermsAndConditions(choice: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let LocationAccessView = storyboard.instantiateViewController(withIdentifier: "LocationAccessViewController") as! LocationAccessViewController
        self.navigationController?.pushViewController(LocationAccessView, animated: true)
    
    }
    
    @IBAction func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
