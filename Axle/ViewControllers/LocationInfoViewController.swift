//
//  LocationInfoViewController.swift
//  Axle
//
//  Created by Rajin Gangadharan on 02/04/25.
//

import UIKit

class LocationInfoViewController: UIViewController {

    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var txtAddressInput: UITextField!
    @IBOutlet weak var txtCurrentAddress: UILabel!
    @IBOutlet weak var btnLogOut: UIButton!
    @IBOutlet weak var btnLocationView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        roundedView.layer.cornerRadius = 20
        roundedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        addSearchIconToTextField()
        
        txtCurrentAddress.text = UserProfileData.shared.getCurrentLocation()
        
        addCardTapGesture()
        
    }
    
    func addSearchIconToTextField() {
        let imageView = UIImageView(frame: CGRect(x: 8.0, y: 8.0, width: 20.0, height: 20.0))
        imageView.image = UIImage(systemName: "Search.png")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .gray
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 36, height: 36))
        paddingView.addSubview(imageView)
        
        txtAddressInput.leftView = paddingView
        txtAddressInput.leftViewMode = .always
    }
    
    func addCardTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardTapped))
        btnLocationView.isUserInteractionEnabled = true
        btnLocationView.addGestureRecognizer(tapGesture)
        
    }
    
    @objc func cardTapped() {
        print("Card tapped!")
        navigateToNextScreen()
    }
    
    func navigateToNextScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let addressViewController = storyboard.instantiateViewController(withIdentifier: "AddressInfoViewController") as! AddressInfoViewController
        
        if let sheet = addressViewController.sheetPresentationController {
            sheet.detents = [.large()]
            sheet.prefersGrabberVisible = false
        }
        
        present(addressViewController, animated: true, completion: nil)
    }
    
    @IBAction func btnLogOutTapped(_ sender: UIButton) {
        UserProfileData.shared.reset()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        var currentStack = self.navigationController?.viewControllers ?? []
        if !currentStack.isEmpty {
            currentStack.removeLast()
        }
        currentStack.append(loginViewController)
        self.navigationController?.setViewControllers(currentStack, animated: true)
    }
    

}
