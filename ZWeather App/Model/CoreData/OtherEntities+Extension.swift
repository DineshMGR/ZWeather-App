//
//  OtherEntities+Extension.swift
//  ZWeather App
//
//  Created by Dinesh G on 04/01/24.
//

import CoreData


extension Location{
    convenience init(context : NSManagedObjectContext, data : [String : Any]) {
        self.init(context: context)
        name = data["name"] as? String
        country = data["country"] as? String
    }
}

extension Forecast{
    convenience init(context: NSManagedObjectContext, data : [String : Any]){
        self.init(context: context)
        if let forecastDayArrJSON = data["forecastday"] as? [[String: Any]]{
            for forecastDayJSON in forecastDayArrJSON{
                let forecastDayData = ForecastDay(context: context, data: forecastDayJSON)
                addToForecastDay(forecastDayData)
            }
        }
        
    }
}

extension ForecastDay{
    convenience init(context : NSManagedObjectContext, data : [String : Any]) {
        self.init(context: context)
        date = data["date"] as? String
        if let dayJSON = data["day"] as? [String: Any]{
            day = Day(context: context, data: dayJSON)
        }
        
        if let hourArrJSON = data["hour"] as? [[String: Any]]{
            for hourJSON in hourArrJSON{
                let hourData = Hour(context: context, data: hourJSON)
                addToHour(hourData)
            }
        }
    }
}

extension Day{
    convenience init(context : NSManagedObjectContext, data : [String : Any]) {
        self.init(context: context)
        minTempC = data["mintemp_c"] as? Double ?? 0.0
        maxTempC = data["maxtemp_c"] as? Double ?? 0.0
        if let conditionJSON = data["condition"] as? [String: Any]{
            condition = Condition(context: context, data: conditionJSON)
        }
    }
}

extension Hour{
    convenience init(context : NSManagedObjectContext, data : [String : Any]) {
        self.init(context: context)
        tempC = data["temp_c"] as? Double ?? 0.0
        time = data["time"] as? String
        if let conditionJSON = data["condition"] as? [String: Any]{
            condition = Condition(context: context, data: conditionJSON)
        }
    }
}

extension Condition{
    convenience init(context : NSManagedObjectContext, data : [String : Any]) {
        self.init(context: context)
        text = data["text"] as? String
        icon = data["icon"] as? String
    }
}
