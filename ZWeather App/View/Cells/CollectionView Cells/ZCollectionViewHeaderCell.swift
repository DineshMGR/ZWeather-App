//
//  ZCollectionViewHeaderCell.swift
//  ZWeather App
//
//  Created by Dinesh G on 05/01/24.
//

import UIKit

class ZCollectionViewHeaderCell: UICollectionReusableView {
    static let identifier = "SectionHeader"

    let titleLabel: SemiBoldTitleLabel = {
        let label = SemiBoldTitleLabel()
        label.text  = "Header"
        label.textAlignment = .left
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElements()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUIElements()
    }
    
    private func setupUIElements(){
        addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }
   
}


#Preview(traits: .defaultLayout, body: {
    ZCollectionViewHeaderCell()
})
