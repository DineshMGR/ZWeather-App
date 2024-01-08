//
//  ZDailyForecastCell.swift
//  ZWeather App
//
//  Created by Dinesh G on 29/12/23.
//

import UIKit

class ZDailyForecastCell: UITableViewCell {
    static let identifier = "ZDailyForecastCell"
    var imageWeather : CustomImageView = {
       let imageView = CustomImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(resource: .partlycloudyday)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    var lblDate: SemiBoldTitleLabel = {
        let label = SemiBoldTitleLabel()
        label.textColor = .darkGray
        label.text = "Date"
        return label
    }()
    
    var lblDescription : SubtitleLabel = {
        let label = SubtitleLabel()
        label.text = "Weather Description"
        return label
    }()
    
    var lblTemperature : TitleLabel = {
        let label = TitleLabel()
        label.text = "0"
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUIElements()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUIElements()
    }
    
    private func setupUIElements(){
        
        let vStackView = UIStackView(arrangedSubviews: [lblDate,lblDescription])
        vStackView.axis = .vertical
        vStackView.distribution = .fill
        vStackView.alignment = .fill
        vStackView.spacing = 5
        vStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let hStackView = UIStackView(arrangedSubviews: [imageWeather, vStackView, lblTemperature])
        hStackView.axis = .horizontal
        hStackView.distribution = .fill
        hStackView.alignment = .center
        hStackView.spacing = 15
        hStackView.translatesAutoresizingMaskIntoConstraints = false
        
        hStackView.addSubview(vStackView)
        contentView.addSubview(hStackView)
        
        NSLayoutConstraint.activate([
            
            imageWeather.heightAnchor.constraint(equalToConstant: 30),
            imageWeather.widthAnchor.constraint(equalTo: imageWeather.heightAnchor),
            vStackView.widthAnchor.constraint(equalTo: lblTemperature.widthAnchor, multiplier: 2.8),
            hStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            hStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -7),
            hStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            hStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
        
    }
}

#Preview(traits: .defaultLayout, body: {
    ZDailyForecastCell()
})
