//
//  CommonFunctions.swift
//  ZWeather App
//
//  Created by Dinesh G on 03/01/24.
//

import UIKit

///For changing the date string to required format
public func dateFormatting(GivenFormat: String, requiredFormat: String,SeperatingString: String?,date:String) -> String{
    var convDate = ""
    if SeperatingString != nil{
        convDate = date.components(separatedBy: SeperatingString!).first ?? ""
    }else{
        convDate = date
    }
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = GivenFormat
    guard let date = dateFormatter.date(from: convDate) else{return ""}
    dateFormatter.dateFormat = requiredFormat
    let resultString = dateFormatter.string(from: date )
    return resultString
}

///For getting corrent time in given format
public func getCurrentTime(formatString: String) -> String{
    let myDate = Date()
    let format = DateFormatter()
    format.dateFormat = formatString
    return format.string(from: myDate)
}


public func showOkAlert(
    title : String = "Alert",
    message : String,
    completion : ((UIAlertAction) -> Void)? = nil,
    vc: UIViewController?
){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .cancel , handler: completion))
    DispatchQueue.main.async {
        if let vc = vc{
            vc.present(alert , animated: true)
        }
    }
}
