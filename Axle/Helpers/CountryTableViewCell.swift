//
//  CountryTableViewCell.swift
//  Axle
//
//  Created by Rajin Gangadharan on 28/03/25.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    private let flagLabel = UILabel()
    private let nameLabel = UILabel()
    private let codeLabel = UILabel()
    private let stackView = UIStackView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCell() {
        //Setup flag icon
        flagLabel.font = UIFont.systemFont(ofSize: 24)
        flagLabel.textAlignment = .center
        flagLabel.setContentHuggingPriority(.required, for: .horizontal)
        flagLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        //Setup name text
        nameLabel.font = UIFont(name: "Gilroy-Medium", size: 17)
        nameLabel.textColor = UIColor.black
        nameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        //Setup phonecode text
        codeLabel.font = UIFont(name: "Gilroy-Medium", size: 17)
        codeLabel.textColor = UIColor.black
        codeLabel.textAlignment = .right
        codeLabel.setContentHuggingPriority(.required, for: .horizontal)
        codeLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        //Setup stackview
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(flagLabel)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(codeLabel)
        
        contentView.addSubview(stackView)

        //Constraints
        NSLayoutConstraint.activate([
            flagLabel.widthAnchor.constraint(equalToConstant: 35),
            
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    //Configure
    func configure(with country: Country) {
        flagLabel.text = country.flag
        nameLabel.text = country.name
        codeLabel.text = country.phoneCode
    }

}
