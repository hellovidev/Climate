//
//  WeatherManager.swift
//  Climate
//
//  Created by Sergey Romanchuk on 15.06.21.
//

import Foundation

struct WeatherManager {
    private let keyAPI = "f7b6fcdf8c3144dc51e771a3ff8899fc"
    private let openWeatherDomainAPI = "https://api.openweathermap.org/data/2.5/weather"
    private let temperatureUnitsType = "metric"
    
    func fetchWeather(cityName: String) {
        let urlString = "\(openWeatherDomainAPI)?q=\(cityName)&appid=\(keyAPI)&units=\(temperatureUnitsType)"
        performRequest(url: urlString)
    }
    
    private func performRequest(url urlString: String) {
        //Step 1: Create URL
        if let url = URL(string: urlString) {
            
            //Step 2:  Create URLSession
            let session = URLSession(configuration: .default)
            
            //Step 3: Give URLSession a task
            let task = session.dataTask(with: url, completionHandler: handle)
            
            //Step 4: Start the task
            task.resume()
        }
    }
    
    private func handle(data: Data?, urlResponse: URLResponse?, error: Error?) -> Void {
        if let errorHandler = error {
            print("Error: \(errorHandler.localizedDescription)")
            return
        }
        
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString)
        } else {
            print("Data is nil!")
            return
        }
    }
}
