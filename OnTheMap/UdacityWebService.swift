//
//  UdacityWebService.swift
//  OnTheMap
//
//  Created by Axel Guilmin on 7/21/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import Foundation

// TODO: Pass HTTP Response status code to closures
class UdacityWebService {
	
	static let BASE_URL = "https://www.udacity.com/api/"

	static func get(#method:String, param:[String:String]?, succes:([String : AnyObject]) -> (), failure:() -> ()) {
		request("GET", method: method, param: param, succes: succes, failure: failure)
	}

	static func post(#method:String, param:[String:String]?, succes:([String : AnyObject]) -> (), failure:() -> ()) {
		request("POST", method: method, param: param, succes: succes, failure: failure)
	}
	
	static func put(#method:String, param:[String:String]?, succes:([String : AnyObject]) -> (), failure:() -> ()) {
		request("PUT", method: method, param: param, succes: succes, failure: failure)
	}
	
	static func delete(#method:String, param:[String:String]?, succes:([String : AnyObject]) -> (), failure:() -> ()) {
		request("DELETE", method: method, param: param, succes: succes, failure: failure)
	}
	
	static func request(httpMethod:String, method:String, param:[String:String]?, succes:([String : AnyObject]) -> (), failure:() -> ()) {
		let urlString = UdacityWebService.BASE_URL + method
		println("↑ " + httpMethod + " " + urlString)
		
		let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
		request.timeoutInterval = 2 //seconds
		request.HTTPMethod = httpMethod
		request.addValue("application/json", forHTTPHeaderField: "Accept")
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		// Pass query parameters
		if param != nil {
			var parsingError: NSError? = nil
			request.HTTPBody = NSJSONSerialization.dataWithJSONObject(["udacity":param!], options: nil, error: &parsingError)
			if(parsingError != nil) {
				println(parsingError?.description)
			}
		}
		
		// Pass cookie
		var xsrfCookie: NSHTTPCookie? = nil
		let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
		for cookie in sharedCookieStorage.cookies as! [NSHTTPCookie] {
			if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
		}
		if let xsrfCookie = xsrfCookie {
			request.addValue(xsrfCookie.value!, forHTTPHeaderField: "X-XSRF-Token")
		}
		
		// Send request
		let session = NSURLSession.sharedSession()
		let task = session.dataTaskWithRequest(request) { data, response, error in
			if error != nil {
				println("↓ " + error.description)
				failure()
				return
			}
			else {
				println("↓ " + (response as! NSHTTPURLResponse).statusCode.description + " " + response.URL!.description)
			}
		
			let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
//			println(NSString(data: newData, encoding: NSUTF8StringEncoding))
			var parsingError: NSError? = nil
			if let json = NSJSONSerialization.JSONObjectWithData(newData, options: NSJSONReadingOptions.AllowFragments, error: &parsingError) as? [String : AnyObject] {
				succes(json)
			}
			else {
				println(parsingError?.description)
				failure()
			}
		}
		task.resume()
	}
}