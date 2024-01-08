//
//  CustomGradiantView.swift
//  ZWeather App
//
//  Created by Dinesh G on 29/12/23.
//

import UIKit
class CustomGradiantView : UIView{
    @IBInspectable
    var startColor : UIColor = UIColor.black
    
    @IBInspectable
    var endColor : UIColor = UIColor.white
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    private lazy var gradientLayer: CAGradientLayer = {
        let l = CAGradientLayer()
        l.startPoint = CGPoint(x: 0.5, y: 0)
        l.endPoint = CGPoint(x: 0.5, y: 1)
        l.colors = [startColor, endColor].map(\.cgColor)
        l.frame = self.bounds
        layer.insertSublayer(l, at: 0)
        return l
    }()
}
