//
//  DataController.swift
//  OnTheMap
//
//  Created by Axel Guilmin on 7/21/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import Foundation

class DataController {
	
	static let singleton = DataController()
	private init() {}
	
	var students = [Student]()
	var user:Student!
	
	func sortStudents() {
		DataController.singleton.students.sort({(a:Student, b:Student) in
			return a.updatedAt.compare(b.updatedAt) == .OrderedDescending
		})
	}
}