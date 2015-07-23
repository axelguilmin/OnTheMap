//
//  StudentLocationTableViewController.swift
//  OnTheMap
//
//  Created by Axel Guilmin on 7/22/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import UIKit

class StudentLocationTableViewController : UITableViewController, UITableViewDataSource, UITableViewDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "loadSucceded:", name:Student.loadLocationsSuccededNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "requestFailedNotification:", name:Student.loadLocationsFailedNotification, object: nil)
	}

	// MARK: Notification

	func loadSucceded(notification: NSNotification) {
		self.tableView.reloadData()
	}

	// MARK: Action
	
	@IBAction func logout(sender: UIBarButtonItem) {
		DataController.singleton.user.logout()
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	@IBAction func pin(sender: UIButton) {
		self.performSegueWithIdentifier("showSetLocation", sender: self)
	}
	
	@IBAction func refresh(sender: UIButton) {
		Student.loadLocations()
	}

	// MARK: UITableViewDataSource

	override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return DataController.singleton.students.count
	}
	
	override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let student = DataController.singleton.students[indexPath.row]
		
		var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
		cell.textLabel?.text = student.fullName
		
		return cell
	}
	
	// MARK: UITableViewDelegate 
	
	override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
		let student = DataController.singleton.students[indexPath.row]
		
		if let url = NSURL(string: student.mediaURL) {
			let app = UIApplication.sharedApplication()
			app.openURL(url)
		}
		
		self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
	}
}