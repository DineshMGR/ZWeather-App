# ZWeather App

## Overview

ZWeather App allows users to check the weather conditions for their current location and search for weather data in other locations. The app utilizes the Common public weather API - WeatherApi for fetching weather information. The project follows the MVVM (Model-View-ViewModel) architecture pattern and makes API calls using URLSession.

## Project Details

- **Platform:** iOS
- **API Used:** Common public weather API - WeatherApi
- **API Call Method:** URLSession
- **Pods:** None
- **Architecture Pattern:** MVVM
- **Local Storage:** CoreData

## App Description

ZWeather App provides the following features:

### 1. Home Screen
- The home screen automatically fetches the weather data for the user's current location.
- Users can refresh the weather data by tapping the location icon in the navigation bar on the top right.

### 2. Search Screen
- A search bar at the top allows users to search for weather data in other locations.

### 3. Weather Information
- Both screens display detailed weather information, including current conditions, hourly forecasts, and a 5-day forecast.

### 4. Design
- The app's user interface is designed programmatically.

### 5. Local Storage
- All the datas stored in CoreData using seperate CoreData stack named ZCoreDataStack.

## Installation

To install and run the ZWeather App:

1. Clone the repository to your local machine.
2. Open the project in Xcode.
3. Build and run the app on an iOS simulator or a physical device.

