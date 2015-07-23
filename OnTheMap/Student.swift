//
//  Student.swift
//  OnTheMap
//
//  Created by Axel Guilmin on 7/21/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import UIKit

struct Student {
	let objectId:String!
	let uniqueKey:String!
	let firstName:String!
	let lastName:String!
	let mapString:String!
	let mediaURL:String!
	let latitude:NSNumber!
	let longitude:NSNumber!
	
	var fullName:String {
		return "\(firstName) \(lastName)"
	}
	
	// TODO: Read this http://chris.eidhof.nl/posts/json-parsing-in-swift.html
	
	init(_ info:[String:AnyObject]) {
		objectId = info["objectId"] as? String
		uniqueKey = info["uniqueKey"] as? String
		firstName = info["firstName"] as? String
		lastName = info["lastName"] as? String
		mapString = info["mapString"] as? String
		mediaURL = info["mediaURL"] as? String
		latitude = info["latitude"] as? NSNumber
		longitude = info["longitude"] as? NSNumber
	}
	
	// TODO: improve using reflexion ?
	func dictionaryAspect() -> [String:AnyObject] {
		var info = [String:AnyObject]()
		
		if(self.objectId != nil) { info["objectId"] = self.objectId }
		if(self.uniqueKey != nil) { info["uniqueKey"] = self.uniqueKey }
		if(self.firstName != nil) {info["firstName"] = self.firstName }
		if(self.lastName != nil) {info["lastName"] = self.lastName }
		if(self.mapString != nil) { info["mapString"] = self.mapString }
		if(self.mediaURL != nil) { info["mediaURL"] = self.mediaURL }
		if(self.latitude != nil) {info["latitude"] = self.latitude }
		if(self.longitude != nil) {info["longitude"] = self.longitude }
		
		return info
	}

	// MARK: Parse API
	
	private static let networkErrorInfo = ["message":"The request timed out.\nPlease check your internet connexion and try again","title":"Network Error"]
	
	static let loadLocationsFailedNotification = "loadFailed"
	static let loadLocationsSuccededNotification = "loadSucceded"
	
	static func loadLocations() {
		// TODO: fetch more than the most recent 100 locations in a network-conscious manner.
		ParseWebService.get(method: "classes/StudentLocation?limit=100",
			param: nil,
			success: {(status:Int, json:[String:AnyObject]?) -> () in
				if(status != 200) { // Request worked but the server responded with an error
					NSNotificationCenter.defaultCenter().postNotificationName(Student.loadLocationsFailedNotification, object: nil, userInfo: ["title":"Request Error ", "message":"Server responded with code \(status.description)"])
				}
				
				if let results = json!["results"] as? [[String:AnyObject]] {
					DataController.singleton.students = [Student]()
					for result in results {
						DataController.singleton.students.append(Student(result))
					}
					NSNotificationCenter.defaultCenter().postNotificationName(Student.loadLocationsSuccededNotification, object: nil, userInfo: json)
				}
			},
			failure: {
				NSNotificationCenter.defaultCenter().postNotificationName(Student.loadLocationsFailedNotification, object: nil, userInfo: Student.networkErrorInfo)
			}
		)
	}
	
	static let sendLocationFailedNotification = "sendLocationFailed"
	static let sendLocationSuccededNotification = "sendLocationSucceded"
	
	func sendLocation() {
		// Did the user already give his location ?
		for student in DataController.singleton.students {
			if student.uniqueKey == self.uniqueKey {
				updateLocation(student.objectId)
				return
			}
		}
		
		// If not create the location
		createLocation()
	}
	
	private func createLocation() {
		ParseWebService.post(method: "classes/StudentLocation",
			param: self.dictionaryAspect(),
			success: {(status:Int, json:[String : AnyObject]?) -> () in
				if(status > 299) { // Request worked but the server responded with an error
					NSNotificationCenter.defaultCenter().postNotificationName(Student.sendLocationFailedNotification, object: nil, userInfo: ["title":"Server Error ", "message":"server responded with code \(status.description)"])
				}
				
				NSNotificationCenter.defaultCenter().postNotificationName(Student.sendLocationSuccededNotification, object: nil, userInfo: json)
			},
			failure: {
				NSNotificationCenter.defaultCenter().postNotificationName(Student.sendLocationFailedNotification, object: nil, userInfo: Student.networkErrorInfo)
		})
	}
	
	private func updateLocation(objectId:String) {
		ParseWebService.put(method: "classes/StudentLocation/" + objectId,
			param: self.dictionaryAspect(),
			success: {(status:Int, json:[String : AnyObject]?) -> () in
				if(status > 299) { // Request worked but the server responded with an error
					NSNotificationCenter.defaultCenter().postNotificationName(Student.sendLocationFailedNotification, object: nil, userInfo: ["title":"Request Error ", "message":"server responded with code \(status.description)"])
				}
				NSNotificationCenter.defaultCenter().postNotificationName(Student.sendLocationSuccededNotification, object: nil, userInfo: json)
			},
			failure: {
				NSNotificationCenter.defaultCenter().postNotificationName(Student.sendLocationFailedNotification, object: nil, userInfo: Student.networkErrorInfo)
		})
	}
	
	// MARK: Udacity API
	
	static let loginFailedNotification = "loginFailed"
	static let loginSuccededNotification = "loginSucceded"
	
	static func login(#email:String, password:String) {
		UdacityWebService.post(
			method:"session",
			param: ["username":email, "password":password],
			success:{(status:Int, json:[String : AnyObject]?) in
				if(status != 200) { // Request worked but the server responded with an error
					let error = json!["error"] as! String
					NSNotificationCenter.defaultCenter().postNotificationName(Student.loginFailedNotification, object: nil, userInfo: ["message":error, "title":"Login Error"])
						return
				}
				
				let account = json!["account"] as! [String:AnyObject]
				let key = account["key"] as! String
				var dict = ["uniqueKey":key]
				
				DataController.singleton.user = Student(dict)
				
				NSNotificationCenter.defaultCenter().postNotificationName(Student.loginSuccededNotification, object: nil, userInfo: json)
			},
			failure:{
				NSNotificationCenter.defaultCenter().postNotificationName(Student.loginFailedNotification, object: nil, userInfo: Student.networkErrorInfo)
			}
		)
	}
	
	func logout() {
		UdacityWebService.delete(method:"session")
	}
	
	func getPublicData() {
		assert(self.uniqueKey != nil, "uniqueKey is needed to request user's public data")
		
		UdacityWebService.get(
			method:"users/" + self.uniqueKey,
			success:{(status:Int, json:[String : AnyObject]?) in
				if let userJson = json!["user"] as? [String:AnyObject] {
					var userDict = self.dictionaryAspect()
					userDict["lastName"] = userJson["last_name"] as! String
					userDict["firstName"] = userJson["first_name"] as! String
					DataController.singleton.user = Student(userDict)
				}
				else {
					// Retry
					self.getPublicData()
				}
			},
			failure:{
				// Retry
				self.getPublicData()
			}
		)
	}
	
}
