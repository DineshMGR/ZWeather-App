//
//  ZHourlyForecastCollectionCell.swift
//  ZWeather App
//
//  Created by Dinesh G on 29/12/23.
//

import UIKit


class ZHourlyForecastCollectionCell: UICollectionViewCell {
    static let identifier = "hourlyForecastCell"
    var bgView : UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var labelTime : SubtitleLabel1 = {
        let label = SubtitleLabel1()
        label.textAlignment = .center
        label.text = "Time"
        return label
    }()
    
    var imageWeather : CustomImageView = {
       let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .partlycloudyday)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    var labelTemperature: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
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
    
    private func setupUIElements(){
        let stackView = UIStackView(arrangedSubviews: [labelTime, imageWeather, labelTemperature])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(bgView)
        bgView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            labelTime.heightAnchor.constraint(equalToConstant: 13),
            labelTemperature.heightAnchor.constraint(equalToConstant: 13),
            imageWeather.heightAnchor.constraint(equalToConstant: 22),
            imageWeather.widthAnchor.constraint(equalToConstant: 22),
            
            stackView.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -10),
            stackView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -10),
            
            bgView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 5),
            bgView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -5),
            bgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            bgView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            
           
        ])
        
    }
    
}


#Preview(traits: .defaultLayout, body: {
    ZHourlyForecastCollectionCell()
})
