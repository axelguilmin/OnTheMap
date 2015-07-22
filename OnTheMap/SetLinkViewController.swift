//
//  SetLinkViewController.swift
//  OnTheMap
//
//  Created by Axel Guilmin on 7/22/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import UIKit
import MapKit

class SetLinkViewController : ViewController, UITextFieldDelegate {
	
	var placemark:CLPlacemark!
	var mapString:String!
	
	// MARK: Outlet
	
	@IBOutlet weak var map: MKMapView!
	@IBOutlet weak var link: UITextField!
	
	// MARK: Layout
	
	override func viewDidAppear(animated: Bool) {
		let span = MKCoordinateSpan(latitudeDelta: 0.2,longitudeDelta: 0.2)
		let region = MKCoordinateRegion(center: placemark.location.coordinate, span: span)
		self.map.setRegion(region, animated: true)
		self.map.userInteractionEnabled = false
		var selectedLocation = MKPointAnnotation()
		selectedLocation.coordinate = placemark.location.coordinate
		self.map.addAnnotation(selectedLocation)
	}
	
	// MARK: Action
	
	@IBAction func cancel(sender: UIButton) {
		// TODO: I'm sure this can be improved !
		self.dismissViewControllerAnimated(true, completion: nil)
		self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
	}

	@IBAction func submit() {
		if link.text.isValidURL() { // Check link validity
			
			NSNotificationCenter.defaultCenter().addObserver(self, selector: "notificationSent:", name: Student.sendLocationSuccededNotification, object: nil)
			NSNotificationCenter.defaultCenter().addObserver(self, selector: "notificationSendFailed:", name: Student.sendLocationFailedNotification, object: nil)
			
			var userDict = DataController.singleton.user.dictionaryAspect()
			userDict["mediaURL"] = link.text
			userDict["longitude"] = placemark.location.coordinate.longitude
			userDict["latitude"] = placemark.location.coordinate.latitude
			userDict["mapString"] = mapString
			DataController.singleton.user = Student(userDict)
			DataController.singleton.user.sendLocation()
		}
		else {
			let message = "You must enter a valid link;\nwith \"http(s)://\"."
			var alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
			alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
		}
	}
	
	// MARK: Notification
	
	func locationSent(notification:NSNotification) {
		self.dismissViewControllerAnimated(true, completion: nil)
		self.presentingViewController!.dismissViewControllerAnimated(true, completion: nil)
	}
	
	func notificationSendFailed(notification:NSNotification) {
		dispatch_async(dispatch_get_main_queue(),{
			var alert = UIAlertController(title: "", message: "The request timed out.\nPlease check your internet connexion and try again", preferredStyle: UIAlertControllerStyle.Alert)
			alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
			self.presentViewController(alert, animated: true, completion: nil)
		})
	}
	
	// MARK: UITextFieldDelegate
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		link.resignFirstResponder()
		self.submit()
		return true
	}
}