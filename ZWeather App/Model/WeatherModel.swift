//
//  WeatherModel.swift
//  ZWeather App
//
//  Created by Dinesh G on 31/12/23.
//

import UIKit
import CoreLocation
import CoreData


struct WeatherModel {
    let WeatherBaseURL = "https://api.weatherapi.com/v1/forecast.json?key=5b99d1b316294de8b4140609240201&&days=5&aqi=no&alerts=no"
    
    
    func fetchWeatherAPIData(parameter: String, isLiveData: Bool = true) async throws{
        let urlString = "\(WeatherBaseURL)&q=\(parameter)"
        do{
            guard let json = try await ZNetworkManager().apiCall(with: urlString) else {return}
            let context = ZCoreDataStack.shared.storeContainer.newBackgroundContext()
            let id = isLiveData ? 0 : 1
            let predicate = NSPredicate(format: "id == %d", id)
            Weather.deleteDataFromLocal(context: context, predicate: predicate)
            parseJSON(json, context: context, isLiveData: isLiveData)
        }
        catch{
            
            throw error
        }
    }
    
    
    
    func parseJSON(_ json: NSDictionary, context: NSManagedObjectContext, isLiveData: Bool = true){
        let id = isLiveData ? 0 : 1 //the live location data stored in id = 0 and the searched data stored in id = 1
        _ = Weather(context: context, data: json, id: id)
        context.saveContext()
    }
    
    
}
