//
//  SetLocationViewController.swift
//  OnTheMap
//
//  Created by Axel Guilmin on 7/22/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import UIKit
import CoreLocation

class SetLocationViewController : ViewController, UITextFieldDelegate  {

	var placemark:CLPlacemark!
	
	// MARK: Outlet
	
	@IBOutlet weak var locationTextField: UITextField!
	@IBOutlet weak var findButton: UIButton!
	
	// MARK: Action
	
	@IBAction func cancel(sender: UIButton) {
		dismissViewControllerAnimated(true, completion: nil)
	}
	@IBAction func find(sender: UIButton) {
		sender.enabled = false
		let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .WhiteLarge)
		activityIndicator.center = self.view.center
		activityIndicator.startAnimating()
		self.view.addSubview(activityIndicator)
		
		let geocoder = CLGeocoder()
		geocoder.geocodeAddressString(locationTextField.text, completionHandler: {(placemarks:[AnyObject]!, error:NSError!) in
			activityIndicator.removeFromSuperview()
			sender.enabled = true
			if error != nil || placemarks == nil || placemarks.count == 0 {
				let message = "Could not geocode the String."
				var alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
				alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
				self.presentViewController(alert, animated: true, completion: nil)
			}
			else {
				self.placemark = placemarks.first as! CLPlacemark
				self.performSegueWithIdentifier("showSetLink", sender: self)
			}
		})
	}
	
	// MARK: UIViewController
	
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if segue.identifier == "showSetLink" {
			let linkVC = segue.destinationViewController as! SetLinkViewController
			linkVC.placemark = placemark
		}
	}
	
	// MARK: UITextFieldDelegate
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		findButton.resignFirstResponder()
		self.find(findButton)
		return true
	}
}