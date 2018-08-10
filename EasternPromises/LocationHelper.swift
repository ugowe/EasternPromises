//
//  LocationHelper.swift
//  EasternPromises
//
//  Created by Joe on 8/10/18.
//  Copyright © 2018 Joe. All rights reserved.
//

import Foundation
import CoreLocation
import PromiseKit

class LocationHelper {
	let coder = CLGeocoder()
	
	// CLPlacemark - A user-friendly description of a geographic coordinate, often containing the name of the place, its address, and other relevant information.
	func getLocation() -> Promise<CLPlacemark> {
		return BrokenPromise()
	}
}
