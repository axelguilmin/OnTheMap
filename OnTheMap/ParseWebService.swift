//
//  ParseWebService.swift
//  OnTheMap
//
//  Created by Axel Guilmin on 7/21/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import Foundation

// TODO: Pass HTTP Response status code to closures
class ParseWebService {
	
	static let BASE_URL = "https://api.parse.com/1/"
	static let PARSE_APP_ID = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
	static let API_KEY = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"

	static func get(#method:String, param:[String:AnyObject]?, succes:([String : AnyObject]) -> (), failure:() -> ()) {
		request("GET", method: method, param: param, succes: succes, failure: failure)
	}
	
	static func post(#method:String, param:[String:AnyObject]?, succes:([String : AnyObject]) -> (), failure:() -> ()) {
		request("POST", method: method, param: param, succes: succes, failure: failure)
	}
	
	static func put(#method:String, param:[String:AnyObject]?, succes:([String : AnyObject]) -> (), failure:() -> ()) {
		request("PUT", method: method, param: param, succes: succes, failure: failure)
	}
	
	static func delete(#method:String, param:[String:AnyObject]?, succes:([String : AnyObject]) -> (), failure:() -> ()) {
		request("DELETE", method: method, param: param, succes: succes, failure: failure)
	}

	
	static func request(httpMethod:String, method:String, param:[String:AnyObject]?, succes:([String : AnyObject]) -> (), failure:() -> ()) {
		let urlString = ParseWebService.BASE_URL + method
		println("↑ " + httpMethod + " " + urlString)
		
		let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
		request.HTTPMethod = httpMethod
		request.timeoutInterval = 2 //seconds
		request.addValue(ParseWebService.PARSE_APP_ID, forHTTPHeaderField: "X-Parse-Application-Id")
		request.addValue(ParseWebService.API_KEY, forHTTPHeaderField: "X-Parse-REST-API-Key")
		request.addValue("application/json", forHTTPHeaderField: "Content-Type")
		
		// Pass query parameters
		if param != nil {
			var parsingError: NSError? = nil
			request.HTTPBody = NSJSONSerialization.dataWithJSONObject(param!, options: nil, error: &parsingError)
			if(parsingError != nil) {
				println(parsingError?.description)
			}
		}
		
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
//			println(NSString(data: data, encoding: NSUTF8StringEncoding))
			if let json = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: nil) as? [String : AnyObject] {
				succes(json)
			}
		}
		task.resume()
	}
}