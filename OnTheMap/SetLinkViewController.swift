//
//  SetLinkViewController.swift
//  OnTheMap
//
//  Created by Axel Guilmin on 7/22/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import UIKit
import MapKit
import AddressBookUI

class SetLinkViewController : ViewController, UITextFieldDelegate {
	
	var placemark:CLPlacemark!
	
	// MARK: Outlet
	
	@IBOutlet weak var map: MKMapView!
	@IBOutlet weak var link: UITextField!
	
	// MARK: Layout
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationSent:", name: Student.sendLocationSuccededNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "requestFailedNotification:", name: Student.sendLocationFailedNotification, object: nil)
	}
	
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
		// If you call this method on the presented view controller itself, it automatically forwards the message to the presenting view controller.
		// Here we want the presentingViewController to be dismissed
		self.presentingViewController!.presentingViewController!.dismissViewControllerAnimated(true, completion: {
			// And dismiss self to be dismiss too (to be deinit)
			self.dismissViewControllerAnimated(false, completion: nil)
		})
	}
	
	@IBAction func submit() {
		if link.text.isValidURL() { // Check link validity
			
			var userDict = DataController.singleton.user.dictionaryAspect()
			userDict["mediaURL"] = link.text
			userDict["longitude"] = placemark.location.coordinate.longitude
			userDict["latitude"] = placemark.location.coordinate.latitude
			userDict["mapString"] = ABCreateStringWithAddressDictionary(placemark.addressDictionary, false);
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
		Student.loadLocations()

		dispatch_async(dispatch_get_main_queue(),{
			self.presentingViewController!.presentingViewController!.dismissViewControllerAnimated(true, completion: {
				self.dismissViewControllerAnimated(false, completion: nil)
			})
		})
	}
	
	// MARK: UITextFieldDelegate
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		link.resignFirstResponder()
		self.submit()
		return true
	}
}