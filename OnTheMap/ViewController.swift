//
//  ViewController.swift
//  OnTheMap
//
//  Created by Axel Guilmin on 7/22/15.
//  Copyright (c) 2015 Axel Guilmin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	// MARK: Layout
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Close keyboard when the screen is touched outside a text field
		let tapGestureRecognizer = UITapGestureRecognizer(target: view, action: Selector("endEditing:"))
		view.addGestureRecognizer(tapGestureRecognizer)
	}
	
	override func viewWillDisappear(animated: Bool) {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
}