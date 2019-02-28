//
//  ShippingTableViewCell.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 2/27/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit

class ShippingTableViewCell: UITableViewCell {
	
//MARK: IBOutlets
	
	@IBOutlet weak var customerNameLabel: UILabel!
	@IBOutlet weak var address1Label: UILabel!
	@IBOutlet weak var address2Label: UILabel!
	@IBOutlet weak var cityLabel: UILabel!
	@IBOutlet weak var stateLabel: UILabel!
	@IBOutlet weak var zipLabel: UILabel!
	@IBOutlet weak var phoneLabel: UILabel!
	
	let shoppingCart = ShoppingCart.sharedInstance
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	
	internal func configureCell() { //PB ep95 2mins
		if let customer = shoppingCart.customer, let shippingAddress = shoppingCart.shippingAddress { //PB ep95 4mins unwrap customer and shippingAddress
			customerNameLabel.text = customer.name //PB ep95 4mins
			phoneLabel.text = customer.phone //PB ep95 4mins
			address1Label.text = shippingAddress.address1 //PB ep95 5mins
			
			if let address2 = shippingAddress.address2 {
				address2Label.text = address2 //PB ep95 5mins
			} else { address2Label.text = "" } //PB ep95 5mins
			cityLabel.text = "\(shippingAddress.city!)" //PB ep95 6mins
			stateLabel.text = shippingAddress.state! //PB ep95 6mins
			zipLabel.text = shippingAddress.zip! //PB ep95 7mins
		}
		
	}
	
}
