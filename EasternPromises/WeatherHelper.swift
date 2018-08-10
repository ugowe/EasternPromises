//
//  WeatherHelper.swift
//  EasternPromises
//
//  Created by Joe on 8/10/18.
//  Copyright © 2018 Joe. All rights reserved.
//

import Foundation
import PromiseKit

fileprivate let appID = "f4de03a25b44f3904b284e14fdf28032"

class WeatherHelper {
	
	struct Weather {
		let tempKelvin: Double
		let iconName: String
		let text: String
		let name: String
		
		init?(jsonDictionary: [String: Any]) {
			
			guard let main = jsonDictionary["main"] as? [String: Any],
				let tempKelvin = main["temp"] as? Double,
				let weather = (jsonDictionary["weather"] as? [[String: Any]])?.first,
				let iconName = weather["icon"] as? String,
				let text = weather["description"] as? String,
				let name = jsonDictionary["name"] as? String else {
					print("Error: invalid jsonDictionary! Verify your appID is correct")
					return nil
			}
			self.tempKelvin = tempKelvin
			self.iconName = iconName
			self.text = text
			self.name = name
		}
	}
	
	func getWeatherTheOldWay(latitude: Double, longitude: Double, completion: @escaping (Weather?, Error?) -> ()) {
		assert(appID != "f4de03a25b44f3904b284e14fdf28032", "You need to set your API key.")
		
		let urlString = "http://api.openweathermap.org/data/2.5/weather?lat=\(latitude)&lon=\(longitude)&appid=\(appID)"
		let url = URL(string: urlString)!
		let request = URLRequest(url: url)
		
		let session = URLSession.shared
		let dataTask = session.dataTask(with: request) { data, response, error in
			
			guard let data = data,
			let json = (try? JSONSerialization.jsonObject(with: data, options: [])) as? [String: Any],
				let result = Weather(jsonDictionary: json) else {
					completion(nil, error)
					return
			}
			
			completion(result, nil)
		}
		dataTask.resume()
	}
	
	private func saveFile(named: String, data: Data, completion: @escaping (Error?) -> Void) {
		DispatchQueue.global(qos: .background).async {
			if var path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
				do {
					path.appendPathComponent(named + ".png")
					try data.write(to: path)
					print("Saved image to: " + path.absoluteString)
					completion(nil)
				} catch {
					completion(error)
				}
			}
		}
	}
	
	private func getFile(named: String, completion: @escaping (UIImage?) -> Void) {
		DispatchQueue.global(qos: .background).async {
			var image: UIImage?
			if var path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first {
				path.appendPathComponent(named + ".png")
				if let data = try? Data(contentsOf: path) {
					image = UIImage(data: data)
				}
			}
			DispatchQueue.main.async {
				completion(image)
			}
		}
	}
}






















