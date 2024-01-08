//
//  Weather+Extension.swift
//  ZWeather App
//
//  Created by Dinesh G on 04/01/24.
//

import CoreData


extension Weather{
    //the live location data stored in id = 0 and the searched data stored in id = 1
    static var liveData : Weather? {
        let predicate = NSPredicate(format: "id == %d", 0)
        let localData : [Weather] = Weather.getLocalData(predicate: predicate)
        return localData.first
    }
    
    static var searchData : Weather?{
        let predicate = NSPredicate(format: "id == %d", 1)
        let localData : [Weather] = Weather.getLocalData(predicate: predicate)
        return localData.first
    }
    
    convenience init (context : NSManagedObjectContext, data : NSDictionary, id:Int){
        self.init(context: context)
        self.id = Int64(id)
        if let currentJSON = data["current"] as? [String: Any]{
            current = Current(context: context, data: currentJSON)
        }
        
        if let locationJSON = data["location"] as? [String: Any]{
            location = Location(context: context, data: locationJSON)
        }
        
        if let forecastJSON = data["forecast"] as? [String: Any]{
            forecast = Forecast(context: context, data: forecastJSON)
        }
        
    }
}
