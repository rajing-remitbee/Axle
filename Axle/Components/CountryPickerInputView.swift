//
//  CountryPickerInputView.swift
//  Axle
//
//  Created by Rajin Gangadharan on 28/03/25.
//

import UIKit

//Country Picker Delegate Protocol
protocol CountryPickerInputViewDelegate: AnyObject {
    func countryPickerInputView(_ view: CountryPickerInputView, didSelect country: Country)
    func countryPickerInputViewDidTapToExpand(_ view: CountryPickerInputView)
}

//Country Input Picker
class CountryPickerInputView: UIView {
    
    weak var delegate: CountryPickerInputViewDelegate? //Delegate
    
    private let flagLabel = UILabel() //Flag Label
    private let arrowImageView = UIImageView() //Arrow Image
    private let stackView = UIStackView() //Stack View
    
    //Selected Country
    var selectedCountry: Country? {
        didSet {
            updateUI()
            if let country = selectedCountry {
                 delegate?.countryPickerInputView(self, didSelect: country)
            }
        }
    }
    
    //Track DropDown Open/Close
    var isDropdownOpen: Bool = false {
        didSet {
            updateAppearance()
        }
    }
    
    //Constructor
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupGesture()
        updateAppearance()
    }
    
    //Required Constructor
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupGesture()
        updateAppearance()
    }
    
    //View Setup
    private func setupView() {

        self.layer.cornerRadius = 10
        self.backgroundColor = UIColor(hex: "E1E1E1")
        
        flagLabel.font = UIFont.systemFont(ofSize: 24)
        flagLabel.textAlignment = .center
        flagLabel.setContentHuggingPriority(.required, for: .horizontal)
        
        let boldConfig = UIImage.SymbolConfiguration(weight: .semibold)
        if let boldImage = UIImage(systemName: "chevron.down", withConfiguration: boldConfig) {
            arrowImageView.image = boldImage
        } else {
            arrowImageView.image = UIImage(systemName: "chevron.down")
        }
        arrowImageView.tintColor = .black
        arrowImageView.contentMode = .scaleAspectFit
        
        
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isUserInteractionEnabled = false
        
        stackView.addArrangedSubview(flagLabel)
        stackView.addArrangedSubview(arrowImageView)
        
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15),
            
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        updateUI()
    }
    
    //Update UI after selection
    private func updateUI() {
        if let country = selectedCountry {
            flagLabel.text = country.flag
        } else {
            flagLabel.text = "🏳️"
        }
    }
    
    //Setup Tap Gesture
    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.addGestureRecognizer(tapGesture)
    }
    
    //Tap Handle
    @objc private func handleTap() {
        delegate?.countryPickerInputViewDidTapToExpand(self)
    }
    
    //Update DropDown Appearance
    private func updateAppearance() {
        if isDropdownOpen {
            self.backgroundColor = .clear
            self.layer.borderWidth = 1
            self.layer.borderColor = UIColor(hex: "#D2D2D2")?.cgColor
        } else {
            self.backgroundColor = UIColor(hex: "E1E1E1")
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    //Country Selection
    func countrySelected(_ country: Country) {
        self.selectedCountry = country
    }
}
