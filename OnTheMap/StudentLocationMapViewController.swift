//
//  StudentLocationMapViewController.swift
//  OnTheMap
//
//  Created by Axel Guilmin on 7/21/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import UIKit
import MapKit

class StudentLocationMapViewController: ViewController, MKMapViewDelegate {

	// MARK: Outlet
	
	@IBOutlet weak var mapView: MKMapView!
	
	// MARK: Layout
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadSucceded:", name:Student.loadLocationsSuccededNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "requestFailedNotification:", name:Student.loadLocationsFailedNotification, object: nil)
		Student.loadLocations()
	}
	
	// MARK: Notification
	
	func loadSucceded(notification: NSNotification) {
		var annotations = [MKPointAnnotation]()
		
		let students = DataController.singleton.students
		for student in students {
			
			let lat = CLLocationDegrees(student.latitude as! Double)
			let long = CLLocationDegrees(student.longitude as! Double)
			let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
			
			var annotation = MKPointAnnotation()
			annotation.coordinate = coordinate
			annotation.title = student.fullName
			annotation.subtitle = student.mediaURL
			
			annotations.append(annotation)
		}
		
		// Add the annotations to the map, need to be on the main thread to appear directly
		dispatch_async(dispatch_get_main_queue(),{
			self.mapView.removeAnnotations(self.mapView.annotations)
			self.mapView.addAnnotations(annotations)
		});
	}
	
	// MARK: Action
	
	@IBAction func refresh(sender: UIButton) {
		Student.loadLocations()
	}

	@IBAction func pin(sender: UIButton) {
		performSegueWithIdentifier("showSetLocation", sender: self)
	}
	
	@IBAction func logout(sender: UIBarButtonItem) {
		DataController.singleton.user.logout()
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	// MARK: MKMapViewDelegate

	func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
		let reuseId = "pin"
		
		var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
		
		if pinView == nil {
			pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
			pinView!.canShowCallout = true
			pinView!.animatesDrop = true
			pinView!.pinColor = .Red
			pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIButton
		}
		else {
			pinView!.annotation = annotation
		}
		
		return pinView
	}
	
	// Respond to taps, opens the system browser to the URL specified in the annotationViews
	func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
		if control == annotationView.rightCalloutAccessoryView {
			if let url = NSURL(string: annotationView.annotation.subtitle!) {
			let app = UIApplication.sharedApplication()
				app.openURL(url)
			}
		}
	}
}