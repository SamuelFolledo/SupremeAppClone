//
//  CheckoutError.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 2/27/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import Foundation
enum CheckoutError: Error {
	case uncheckedAgreeButton
	case uncheckedCaptcha
	case incompleteForm
	case invalidEmail
	case incorrectPasswordLenght
}
