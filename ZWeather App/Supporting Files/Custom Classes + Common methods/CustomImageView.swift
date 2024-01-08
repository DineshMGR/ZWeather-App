//
//  CustomImageView.swift
//  ZWeather App
//
//  Created by Dinesh G on 03/01/24.
//

import UIKit
var imageCahe = NSCache<AnyObject, AnyObject>()

//MARK: - Cache images for effient image loading
class CustomImageView: UIImageView{
    
    var task: URLSessionDataTask?
    
    func loadImage(url: String){
        
        if let url = URL(string: url){
            image = nil
            
            if let task = task{
                task.cancel()
            }
            if let imageFromCache = imageCahe.object(forKey: url.absoluteString as AnyObject) as? UIImage{
                self.image = imageFromCache
                return
            }
            task = URLSession.shared.dataTask(with: url){ data, responsse, error in
                guard let data = data, let newImage = UIImage(data: data) else{
                    
                    print("Couldn't load image from url:\(url)")
                    return
                }
                
                imageCahe.setObject(newImage, forKey: url.absoluteString as AnyObject)
                DispatchQueue.main.async {
                    self.image = newImage
                }
                
                
            }
            task?.resume()
        }
    }
        
}
