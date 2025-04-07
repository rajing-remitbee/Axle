//
//  UIViewController.swift
//  Axle
//
//  Created by Rajin Gangadharan on 07/04/25.
//

import UIKit

extension UIViewController {
    func showToast(message: String) {
        let toastView = ToastView(message: message)
        toastView.show(in: self)
    }
}
