//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Axel Guilmin on 7/20/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import UIKit

class LoginViewController: ViewController, UITextFieldDelegate {
	
	// MARK: Outlet
	
	@IBOutlet var emailTextField: UITextField!
	@IBOutlet var passwordTextField: UITextField!
	@IBOutlet var loginButton: UIButton!
	
	// MARK: Layout
	
	override func viewDidAppear(animated: Bool) {
		super.viewDidAppear(animated)
		
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginSucceded:", name:Student.loginSuccededNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: "loginFailed:", name:Student.loginFailedNotification, object: nil)
	}
	
	override func viewDidDisappear(animated: Bool) {
		super.viewDidDisappear(animated)
		
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
		
	// MARK: Action
	
	@IBAction func login() {
		let email = emailTextField.text
		let password = passwordTextField.text
		
		Student.login(email: email, password: password)
		
		self.loginButton.enabled = false
	}
	
	@IBAction func signUp() {
		if let url = NSURL(string: "https://www.udacity.com/account/auth#!/signup") {
			UIApplication.sharedApplication().openURL(url)
		}
	}
	
	// MARK: Notification
	
	func loginSucceded(notification: NSNotification) {
		self.loginButton.enabled = true
		
		let json = notification.userInfo as! [String:AnyObject]
		// Manage login errors
		let status = json["status"] as? NSInteger
		if status != nil && status! > 399 {
			let error = json["error"] as! String
			dispatch_async(dispatch_get_main_queue(),{
				var alert = UIAlertController(title: "", message: error, preferredStyle: UIAlertControllerStyle.Alert)
				alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
				self.presentViewController(alert, animated: true, completion: nil)
			})
			return
		}
		// User logged in
		DataController.singleton.user.getPublicData()
		dispatch_async(dispatch_get_main_queue(),{
			self.performSegueWithIdentifier("showStudentLocation", sender: self)
		});
	}
	
	func loginFailed(notification: NSNotification) {
		self.loginButton.enabled = true
		requestFailedNotification(notification)
	}
	
	// MARK: UITextFieldDelegate
	
	func textFieldShouldReturn(textField: UITextField) -> Bool {
		switch textField {
		case emailTextField:
			passwordTextField.becomeFirstResponder()
		case passwordTextField:
			passwordTextField.resignFirstResponder()
			login()
		default:
			println("LoginViewController:textFieldShouldReturn - unmanaged text field")
		}
		return true
	}
}
