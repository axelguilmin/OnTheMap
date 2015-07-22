//
//  Array.swift
//  OnTheMap
//
//  Created by Axel Guilmin on 7/21/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import Foundation

// Source: http://stackoverflow.com/a/24029847/1327557
extension Array {
	/// This extension will let you shuffle a mutable Array instance in place
	/// var numbers = [1, 2, 3, 4, 5, 6, 7, 8]
	///	numbers.shuffle()
	mutating func shuffle() {
		if count < 2 { return }
		for i in 0..<(count - 1) {
			let j = Int(arc4random_uniform(UInt32(count - i))) + i
			swap(&self[i], &self[j])
		}
	}
	
	/// This extension will let you retrieve a shuffled copy of an Array instance:
	/// let numbers = [1, 2, 3, 4, 5, 6, 7, 8]
	/// let mixedup = numbers.shuffled()
	func shuffled() -> [T] {
		if count < 2 { return self }
		var list = self
		for i in 0..<(list.count - 1) {
			let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
			swap(&list[i], &list[j])
		}
		return list
	}
}
