//
//  GCD.swift
//  OnTheMap
//
//  Created by Axel Guilmin on 7/21/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import Foundation

// Source: http://stackoverflow.com/a/24318861/1327557
func delay(delay:Double, closure:()->()) {
	dispatch_after(
		dispatch_time(
			DISPATCH_TIME_NOW,
			Int64(delay * Double(NSEC_PER_SEC))
		),
		dispatch_get_main_queue(), closure)
}

func dispatch_main(closure:()->()) {
	dispatch_async(dispatch_get_main_queue(),{
		closure
	})
}
