//
//  ToastView.swift
//  Axle
//
//  Created by Rajin Gangadharan on 07/04/25.
//

import UIKit

class ToastView: UIView {
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    private let padding: CGFloat = 16
    private let cornerRadius: CGFloat = 10
    private let backgroundColour: UIColor = UIColor.black.withAlphaComponent(0.8)
    private let animationDuration: TimeInterval = 0.3
    private let displayDuration: TimeInterval = 3.0
    
    init(message: String) {
        super.init(frame: .zero)
        
        messageLabel.text = message
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        addSubview(messageLabel)
        backgroundColor = self.backgroundColour
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        alpha = 0
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding),
            messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding),
            messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding)
        ])
    }
    
    func show(in viewController: UIViewController) {
        guard let window = viewController.view.window ?? viewController.view.window else { return }
        
        translatesAutoresizingMaskIntoConstraints = false
        window.addSubview(self)
        
        NSLayoutConstraint.activate([
            centerXAnchor.constraint(equalTo: window.centerXAnchor),
            bottomAnchor.constraint(equalTo: window.safeAreaLayoutGuide.bottomAnchor, constant: -100),
            leadingAnchor.constraint(greaterThanOrEqualTo: window.safeAreaLayoutGuide.leadingAnchor, constant: padding),
            trailingAnchor.constraint(lessThanOrEqualTo: window.safeAreaLayoutGuide.trailingAnchor, constant: -padding)
        ])
        
        window.layoutIfNeeded()
        
        UIView.animate(withDuration: animationDuration) {
            self.alpha = 1
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + self.displayDuration) {
                self.hide()
            }
        }
    }

    private func hide() {
        UIView.animate(withDuration: animationDuration) {
            self.alpha = 0
        } completion: { _ in
            self.removeFromSuperview()
        }
    }
}
