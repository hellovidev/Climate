//
//  WeatherManager.swift
//  Climate
//
//  Created by Sergey Romanchuk on 15.06.21.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    private let keyAPI = "f7b6fcdf8c3144dc51e771a3ff8899fc"
    private let openWeatherDomainAPI = "https://api.openweathermap.org/data/2.5/weather"
    private let temperatureUnitsType = "metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(openWeatherDomainAPI)?q=\(cityName)&appid=\(keyAPI)&units=\(temperatureUnitsType)"
        performRequest(url: urlString)
    }
    
    func fetchWeather(lat: CLLocationDegrees, lon: CLLocationDegrees) {
        let urlString = "\(openWeatherDomainAPI)?lat=\(lat)&lon=\(lon)&appid=\(keyAPI)&units=\(temperatureUnitsType)"
        performRequest(url: urlString)
    }
    
    private func performRequest(url urlString: String) {
        //Step 1: Create URL
        if let url = URL(string: urlString) {
            
            //Step 2:  Create URLSession
            let session = URLSession(configuration: .default)
            
            //Step 3: Give URLSession a task
            //let task = session.dataTask(with: url, completionHandler: handle)
            let task = session.dataTask(with: url) { data, urlResponse, error in
                if let errorHandler = error {
                    //print("Error: \(errorHandler.localizedDescription)")
                    self.delegate?.didFailWithError(error: errorHandler)
                    return
                }
                
                if let safeData = data {
                    if let weather = self.parseJSON(weatherData: safeData) {
                        self.delegate?.didUpdateWeather(weather: weather)
                        print(weather.cityName)
                    }
//                    let dataString = String(data: safeData, encoding: .utf8)
//                    print(dataString)
                } else {
                    print("Data is nil!")
                    return
                }
            }
            
            //Step 4: Start the task
            task.resume()
        }
    }
    
    private func parseJSON(weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            print("City: \(decodedData.name)")
            print("Temperature: \(decodedData.main.temp)")
            print("Description: \(decodedData.weather[0].description)")
            print("Conditions: \(decodedData.weather[0].id)")
            
            let city = decodedData.name
            let temp = decodedData.main.temp
            let id = decodedData.weather[0].id
            
            let weather = WeatherModel(conditionId: id, cityName: city, temperature: temp)
            return weather
        } catch {
            //print(error.localizedDescription)
            self.delegate?.didFailWithError(error: error)
            return nil
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
