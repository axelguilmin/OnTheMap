//
//  ViewController.swift
//  OnTheMap
//
//  Created by Axel Guilmin on 7/22/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	// MARK: Layout
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Close keyboard when the screen is touched outside a text field
		let tapGestureRecognizer = UITapGestureRecognizer(target: view, action: Selector("endEditing:"))
		view.addGestureRecognizer(tapGestureRecognizer)
	}
	
	deinit {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	// MARK: Network utils
	
	/// Default behavior to handle network and request errors
	func requestFailedNotification(notification:NSNotification) {
		let message = notification.userInfo!["message"] as? String
		var title = notification.userInfo!["title"] as? String
		if(title == nil) { title = "" } // Else the message would be displayed in bold
		
		dispatch_async(dispatch_get_main_queue(),{
			var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
			alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
		})
	}
}