//
//  ViewController.swift
//  Climate
//
//  Created by Sergey Romanchuk on 15.06.21.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController  {
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    private var weatherManager = WeatherManager()
    private let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Show pop up which ask user to allow current location
        /*Well, the reason to write delegate before requests is because we have to set the current class as the delegate to be able to register with
         the locationManager and to be able to respond when requestLocation actually triggers this method.*/
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        searchTextField.delegate = self
    }

    @IBAction func searchButtonAction(_ sender: UIButton) {
        searchTextField.endEditing(true)
        print(searchTextField.text!)
    }
    
    @IBAction func currentLocationAction(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Notify when user press return key button
        searchTextField.endEditing(true)
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        if searchTextField.text != "" {
            return true
        } else {
            searchTextField.placeholder = "Type something here!"
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let city = searchTextField.text {
            weatherManager.fetchWeather(cityName: city)
        }
        
        searchTextField.text = ""
    }
    
}

// MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    func didFailWithError(error: Error) {
        print(error.localizedDescription)
    }
    
    func didUpdateWeather(weather: WeatherModel) {
        DispatchQueue.main.async { [weak self] in
            self?.conditionImageView.image = UIImage(systemName: weather.getConditionName)
            self?.temperatureLabel.text = weather.temperatureString
            self?.cityLabel.text = weather.cityName
        }

    }
    
}

// MARK: - CLLocationManagerDelegate

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            if let location = locations.last {
                manager.stopUpdatingLocation()
                let lat = location.coordinate.latitude
                let lon = location.coordinate.longitude
                weatherManager.fetchWeather(lat: lat, lon:lon)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
}

/*
 api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={API key}
 */
