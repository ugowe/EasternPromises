//
//  WeatherViewController.swift
//  EasternPromises
//
//  Created by Joe on 8/10/18.
//  Copyright © 2018 Joe. All rights reserved.
//

import UIKit
import Foundation
import PromiseKit
import CoreLocation

private let errorColor = UIColor(red: 0.96, green: 0.667, blue: 0.690, alpha: 1)
private let oneHour: TimeInterval = 3600 //Seconds per hour
private let randomCities = [("Tokyo", "JP", 35.683333, 139.683333),
							("Jakarta", "ID", -6.2, 106.816667),
							("Delhi", "IN", 28.61, 77.23),
							("Manila", "PH", 14.58, 121),
							("São Paulo", "BR", -23.55, -46.633333)]

class WeatherViewController: UIViewController {

	@IBOutlet weak var placeLabel: UILabel!
	@IBOutlet weak var tempLabel: UILabel!
	@IBOutlet weak var iconImageView: UIImageView!
	@IBOutlet weak var conditionLabel: UILabel!
	
	
	let weatherAPI = WeatherHelper()
	let locationHelper = LocationHelper()
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		updateWithCurrentLocation()
	}
	
	private func updateWithCurrentLocation() {
		handleMockLocation()
	}
	
	fileprivate func handleMockLocation() {
		self.handleLocation(city: "Athens", state: "Greece", latitude: 37.966667, longitude: 23.716667)
	}
	
	
	func handleLocation(placemark: CLPlacemark) {
		handleLocation(city: placemark.locality,
					   state: placemark.administrativeArea,
					   latitude:  placemark.location!.coordinate.latitude,
					   longitude: placemark.location!.coordinate.longitude)
	}
	
	func handleLocation(city: String?, state: String?, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
		if let city = city, let state = state {
			self.placeLabel.text = "\(city), \(state)"
		}
		
		weatherAPI.getWeatherTheOldWay(latitude: latitude, longitude: longitude) { weather, error in
			
			guard let weather = weather else {
				self.tempLabel.text = "--"
				self.conditionLabel.text = error?.localizedDescription ?? "--"
				return
			}
			
			self.updateUIWithWeather(weather: weather)
		}
	}
	
	private func updateUIWithWeather(weather: WeatherHelper.Weather) {
		let tempMeasurement = Measurement(value: weather.tempKelvin, unit: UnitTemperature.kelvin)
		let formatter = MeasurementFormatter()
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = .none
		formatter.numberFormatter = numberFormatter
		let tempStr = formatter.string(from: tempMeasurement)
		self.tempLabel.text = tempStr
		self.conditionLabel.text = weather.text
		self.conditionLabel.textColor = UIColor.white
	}

	@IBAction func showRandomWeather(_ sender: Any) {
	}
	

}

// MARK: - UITextFieldDelegate

extension WeatherViewController: UITextFieldDelegate {
	
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		guard let _ = textField.text else { return true }
		
		handleMockLocation()
		
		return true
	}
	
}
