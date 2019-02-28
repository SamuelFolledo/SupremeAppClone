//
//  String+extension.swift
//  FolledoEcommerceApp
//
//  Created by Samuel Folledo on 11/20/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit //PB ep9 22mins

extension String { //PB ep9 23mins
	
	var isValidEmail: Bool {
		let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
		let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailFormat)
		return emailPredicate.evaluate(with: self)
	}
	
	func stripFileExtension() -> String { //PB ep9 23-25mins strips extension like .jpg or .png
		if self.contains("."), let index = self.firstIndex(of: ".") { //PB ep9 23mins if string contains "." //get the index of . and
			let endIndex = self.index(index, offsetBy: -1) //PB ep9 get the index before
			return String(self[...endIndex]) //PB ep9 return the string until the endIndex (removing anything "." and everything after the period)
		}
		return self //PB ep9 else if no dot then return self
	}
	
	
	func maskedPlusLast4() -> String { //PB ep91 7mins method to only show the last 4 digits of the credit card
		let last4CardNumber = self.suffix(4) //PB ep91 8mins
		return "****\(last4CardNumber)" //PB ep91 9mins
	}
	
	func trimmedString() -> String { //method that removes string's left and right white spaces and new lines
		let newWord: String = self.trimmingCharacters(in: .whitespacesAndNewlines)
		print(newWord)
		return newWord
	}
}
