//
//  PaymentInfoTableViewCell.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 2/27/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit

class PaymentInfoTableViewCell: UITableViewCell {
	
//MARK: IBOutlets
	@IBOutlet weak var cardImageView: UIImageView!
	@IBOutlet weak var cardNumberLabel: UILabel!
	@IBOutlet weak var cardNameLabel: UILabel!
	@IBOutlet weak var cardExpirationLabel: UILabel!
	
	let shoppingCart = ShoppingCart.sharedInstance
	
	
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
	
	internal func configureCell() { //PB ep95 9mins
		print("Credit card is \(shoppingCart.creditCard)")
		if let creditCard = shoppingCart.creditCard { //PB ep95 10mins
			let cardType:String = creditCard.type! //PB ep95 10mins
			
			cardImageView.image = UIImage(named: "\(cardType)") //PB ep95 10mins
			cardNumberLabel.text = creditCard.cardNumber?.maskedPlusLast4() //PB ep95 11mins
			cardNameLabel.text = "\((creditCard.cardFirstName)!) \((creditCard.cardLastName)!)" //PB ep95 12mins
			cardExpirationLabel.text = "\(creditCard.expMonth)/\(creditCard.expYear)" //PB ep95 12mins
		}
	}
	
}
