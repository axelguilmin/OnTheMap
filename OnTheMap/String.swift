//
//  String.swift
//  OnTheMap
//
//  Created by Axel Guilmin on 7/22/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import UIKit

extension String {
	func isValidURL() -> Bool {
		if let url = NSURL(string: self) {
			return UIApplication.sharedApplication().canOpenURL(url)
		}
		return false
	}
}
