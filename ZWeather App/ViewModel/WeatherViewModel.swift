//
//  WeatherViewModel.swift
//  ZWeather App
//
//  Created by Dinesh G on 02/01/24.
//

import Foundation
import CoreLocation

class WeatherViewModel{
    
    private var model = WeatherModel()
    var dailyForecastData : [ForecastDay] = []
    var hourlyForecastData : [Hour] = []
    var currentData: Current?
    var location : Location?
    
    var dataFetched: (() -> Void)?
    var updateError: ((String) -> Void)?
    
    //for fetching Searched data
    func fetchApiData(_ cityName: String){
        fetchData(parameter: cityName, isLiveData: false)
    }
    
    //for fetching live location data
    func fetchApiData(latitude: CLLocationDegrees, longitude: CLLocationDegrees){
        fetchData(parameter: "\(latitude),\(longitude)")
    }
    
    //isLiveData - is true means fetching live location data, else fetching the searched data
    func fetchData(parameter:String, isLiveData: Bool = true){
        Task{
            do{
                try await model.fetchWeatherAPIData(parameter: parameter, isLiveData: isLiveData)
                DispatchQueue.main.async{ [weak self] in
                    self?.fetchLocalData(isLiveData: isLiveData)
                    self?.dataFetched?()
                }
            }
            catch{
                var msg = ""
                if error is ZError{
                    let err = error as? ZError
                    if (err?.message ?? "").lowercased().contains("no matching location found"){
                        msg = "Sorry, No matching location found."
                    }else{
                        msg = "Oops! Something went wrong. Please check your internet connection and try again."
                    }
                }else{
                    msg = "Oops! Something went wrong. Please check your internet connection and try again."
                    print(error.localizedDescription)
                }
                updateError?(msg)
            }
        }
    }
    
    
    func fetchLocalData(isLiveData: Bool = true){
        //let weatherData : [Weather] = Weather.getLocalData()
        let weatherdata = isLiveData ? Weather.liveData : Weather.searchData
        if let weather = weatherdata{
            if let currentData = weather.current {
                self.currentData = currentData
            }
            
            if let locationData = weather.location{
                self.location = locationData
            }
            if let forecastDataSet = weather.forecast?.forecastDay{
                dailyForecastData = (forecastDataSet.allObjects as! [ForecastDay]).sorted{$0.date ?? "" < $1.date ?? ""}
                let reqData = dailyForecastData.filter{$0.date == getCurrentTime(formatString: "yyyy-MM-dd")}
                if let todaydata = reqData.first{
                    if let hourDataSet = todaydata.hour{
                        hourlyForecastData = (hourDataSet.allObjects as! [Hour]).sorted{$0.time ?? "" < $1.time ?? ""}
                    }
                }
            }
            
        }
    }
    
    /// For getting current time start value. Ex: current = 13:15  -> 13:00
    func getCurrentTimeIndex() -> Int{
        let currentDate = Date()
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.hour, .minute], from: currentDate)
        
        if let hour = components.hour {
            // Setting the time to the start of the current hour
            let startTime = calendar.date(bySettingHour: hour, minute: 0, second: 0, of: currentDate)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            
            if let startTime = startTime {
                let formattedStartTime = dateFormatter.string(from: startTime)
                let timeArr = hourlyForecastData.map{val in
                    
                    return dateFormatting(GivenFormat: "yyyy-MM-dd HH:mm", requiredFormat: "HH:mm", SeperatingString: nil, date: val.time ?? "")
                }
                if timeArr.contains(formattedStartTime), let index = timeArr.firstIndex(of: formattedStartTime){
                    return index
                }
            }
        }
        return 0
    }
    
}
