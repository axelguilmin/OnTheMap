//
//  NSDate.swift
//  OnTheMap
//
//  Created by Axel Guilmin on 7/25/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import Foundation

// source: http://stackoverflow.com/a/28016692/1327557
extension NSDate {
	var isoString: String {
		let formatter = NSDateFormatter()
		formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
		formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
		formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
		formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
		return formatter.stringFromDate(self)
	}
}

func dateFromIsoString(isoString:String?) -> NSDate? {
	if isoString == nil { return nil }
	let formatter = NSDateFormatter()
	formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z"
	formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
	formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
	formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
	return formatter.dateFromString(isoString!)
}