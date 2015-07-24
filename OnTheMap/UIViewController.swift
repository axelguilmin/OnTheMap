//
//  UIViewController.swift
//  OnTheMap
//
//  Created by Axel Guilmin on 7/24/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import UIKit

// Source: http://stackoverflow.com/a/30344412/1327557
extension UIViewController{
	var isOnScreen: Bool{
		return self.isViewLoaded() && view.window != nil
	}
}
