//
//  UITextField+extension.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 3/2/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
	
	var hasError: UITextField {
		self.layer.borderColor = UIColor.red.cgColor
		return self
	}
	
//	func hasError() -> UITextField {
//		return self.layer.borderColor = UIColor.red.cgColor as? CGColor
//	}
	
	func hasNoError() -> UITextField {
		self.layer.borderColor = UIColor.clear.cgColor
		return self
	}
	
}
