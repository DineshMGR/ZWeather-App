//
//  Current+Extension.swift
//  ZWeather App
//
//  Created by Dinesh G on 04/01/24.
//

import CoreData

extension Current{
    convenience init(context : NSManagedObjectContext, data : [String : Any]) {
        self.init(context: context)
        feelsLikeC = data["feelslike_c"] as? Double ?? 0.0
        tempC = data["temp_c"] as? Double ?? 0.0
        lastUpdated = data["last_updated"] as? String
        windKmph = data["wind_kph"] as? Double ?? 0.0
        pressureMb = data["pressure_mb"] as? Double ?? 0.0
        uv = data["uv"] as? Double ?? 0.0
        if let conditionJSON = data["condition"] as? [String: Any]{
            condition = Condition(context: context, data: conditionJSON)
        }
    }
}
