//
//  OrderCompletedViewController.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 2/28/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit

class OrderCompletedViewController: UIViewController {
	
//MARK: IBOutlets
	
	@IBOutlet weak var transactionIdButton: UIButton!
	@IBOutlet weak var emailButton: UIButton!
	@IBOutlet weak var continueButton: UIButton!
	
//MARK: Properties
	var shoppingCart = ShoppingCart.sharedInstance
	
	
	
//MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let now = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyyMMdd"
		let currentDate: Int = Int(dateFormatter.string(from: now))!
		
		let transactionId: String = "\(Service.randomString(length: 4))\(Service.randomString(length: 4))\(Service.randomString(length: 4))\(currentDate)\(Service.randomString(length: 4))"
		transactionIdButton.setTitle(transactionId, for: .normal)
		
		guard let email: String = shoppingCart.customer?.email else { return }
		emailButton.setTitle(email, for: .normal)
    }
	
	
	
//MARK: IBActions
	@IBAction func transactionIdButtonTapped(_ sender: Any) {
		UIPasteboard.general.string = transactionIdButton.currentTitle
		transactionIdButton.setTitleColor(.blue, for: .normal)
	}
	
	@IBAction func emailButtonTapped(_ sender: Any) {
		UIPasteboard.general.string = emailButton.currentTitle
		emailButton.setTitleColor(.blue, for: .normal)
	}
	
	@IBAction func continueButtonTapped(_ sender: Any) {
		let viewController: UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC")
		self.present(viewController, animated: false, completion: nil)
		shoppingCart.reset()
	}
}
