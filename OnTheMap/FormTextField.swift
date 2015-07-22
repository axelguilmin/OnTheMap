//
//  FormTextField.swift
//  OnTheMap
//
//  Source: http://stackoverflow.com/a/27553283/1327557
//

import UIKit

@IBDesignable
class FormTextField: UITextField {
	
	@IBInspectable var inset: CGFloat = 0
	
	override func textRectForBounds(bounds: CGRect) -> CGRect {
		return CGRectInset(bounds, inset, inset)
	}
	
	override func editingRectForBounds(bounds: CGRect) -> CGRect {
		return textRectForBounds(bounds)
	}
}