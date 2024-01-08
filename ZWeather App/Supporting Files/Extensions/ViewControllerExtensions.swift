//
//  ViewControllerExtensions.swift
//  ZWeather App
//
//  Created by Dinesh G on 05/01/24.
//

import UIKit

extension UIViewController {
    //Showing and hiding indicator in viewcontroller 

    func showActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.color = .gray 
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        if let activityIndicator = view.subviews.first(where: { $0 is UIActivityIndicatorView }) as? UIActivityIndicatorView {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
}
