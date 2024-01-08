//
//  CustomAdditionalWeatherDetailsView.swift
//  ZWeather App
//
//  Created by Dinesh G on 04/01/24.
//

import UIKit

class CustomAdditionalWeatherDetailsView: UIView {

    var iconImgView : UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .wind)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var labelTitle: SubtitleLabel = {
        let label = SubtitleLabel()
        label.textColor = .systemGray3
        label.text = "WIND"
        return label
    }()
    
    var labelValue: TitleLabel = {
        let label = TitleLabel()
        label.textColor = .black
        label.text = "0"
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
    
    func setupUIElements(){
        
        let stackView = UIStackView(arrangedSubviews: [labelTitle,labelValue])
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        addSubview(iconImgView)
        
        NSLayoutConstraint.activate([
            iconImgView.centerYAnchor.constraint(equalTo: centerYAnchor),
            iconImgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            iconImgView.heightAnchor.constraint(equalToConstant: 25),
            iconImgView.widthAnchor.constraint(equalToConstant: 30),
            
            stackView.leadingAnchor.constraint(equalTo: iconImgView.trailingAnchor, constant: 15),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    

}

#Preview(traits: .defaultLayout, body: {
    CustomAdditionalWeatherDetailsView()
})
