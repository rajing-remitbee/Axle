//
//  UITextField.swift
//  Axle
//
//  Created by Rajin Gangadharan on 01/04/25.
//

import UIKit

extension UITextField {
    
    func setupPadding(left: CGFloat? = nil, right: CGFloat? = nil, top: CGFloat? = nil, bottom: CGFloat? = nil){
        let padding = UIEdgeInsets.init(top: top ?? 0, left: left ?? 0, bottom: bottom ?? 0, right: right ?? 0)
        self.leftView = UIView(frame: CGRect.init(x: 0, y: 0, width: padding.left, height: 0))
        self.leftViewMode = .always
        self.rightView = UIView(frame: CGRect.init(x: 0, y: 0, width: padding.right, height: 0))
        self.rightViewMode = .always
    }
    
}
