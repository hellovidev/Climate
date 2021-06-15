//
//  WeatherData.swift
//  Climate
//
//  Created by Sergey Romanchuk on 15.06.21.
//

import Foundation

struct WeatherData: Decodable {
    let name: String
    let main: Main
    let weather: [Weather]
    
}

struct Main: Decodable {
    let temp: Float
    let pressure: Float
    let humidity: Float
    let temp_min: Float
    let temp_max: Float
}

struct Weather: Decodable {
    let id: Int
    let description: String
}
