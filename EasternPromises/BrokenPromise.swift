//
//  BrokenPromises.swift
//  EasternPromises
//
//  Created by Joe on 8/10/18.
//  Copyright © 2018 Joe. All rights reserved.
//

import Foundation
import PromiseKit

func BrokenPromise<T>(method: String = #function) -> Promise<T> {
	return Promise<T>() { seal in
		let err = NSError(domain: "EasternPromises", code: 0, userInfo: [NSLocalizedDescriptionKey: "'\(method)' has not been implemented yet."])
		
		seal.reject(err)
	}
}
