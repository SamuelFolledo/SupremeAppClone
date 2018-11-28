//
//  DetailSummaryView.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 11/27/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit


class DetailSummaryView: UIView {
   
   @IBOutlet weak var manufacturerLabel: UILabel! //PB ep68 7mins since conte
   
   @IBOutlet weak var productNameLabel: UILabel! //PB ep68 7mins
//   @IBOutlet weak var listPriceLabel: UILabel! //PB ep68 7mins
   @IBOutlet weak var dealPriceLabel: UILabel! //PB ep68 7mins
//   @IBOutlet weak var priceSavedDollarLabel: UILabel! //PB ep68 7mins
//   @IBOutlet weak var priceSavedPercentLabel: UILabel! //PB ep68 7mins
//   @IBOutlet weak var inStockLabel: UILabel! //PB ep68 7mins
   @IBOutlet weak var qtyLeftLabel: UILabel! //PB ep68 7mins
   @IBOutlet weak var sizeButton: UIButton!
   @IBOutlet weak var descriptionLabel: UILabel!
//   @IBOutlet weak var quantityButton: UIButton! //PB ep68 7mins
   @IBOutlet weak var addToCartButton: UIButton! //PB ep68 7mins
   @IBOutlet weak var productImageView: UIImageView! //PB ep68 7mins
   @IBOutlet weak var userRating: UserRating! //PB ep68 7mins
   
   
   
   override init(frame: CGRect) { //PB ep68 8mins because we subclass the UIView, we need to override the initialization of the UIView
      super.init(frame: frame) //PB ep68 9mins
      
      
   }
   
   required init?(coder aDecoder: NSCoder) { //PB ep68 9mins the other required method
      super.init(coder: aDecoder) //PB ep68 9mins
      
      
   }
   
   internal func updateView(with product: Product) { //PB ep68 10mins
      
      addToCartButton.layer.borderWidth = 1.5
      addToCartButton.layer.borderColor = UIColor.clear.cgColor
      addToCartButton.layer.cornerRadius = 5
      
      sizeButton.layer.borderWidth = 1.5
      sizeButton.layer.borderColor = UIColor.darkGray.cgColor
      sizeButton.layer.cornerRadius = 5
      
      
      //      print("Product name: \(String(describing: product.name))") //PB ep68 10mins
      //Set default state //PB ep69 0mins
//      qtyLeftLabel.isHidden = true //PB ep69 1mins
      sizeButton.alpha = 0
//      quantityButton.setTitle("Quantity: 1", for: .normal) //PB ep69 1mins
//      quantityButton.isEnabled = true //PB ep69 1mins
//      quantityButton.alpha = 1.0 //PB ep69 2mins make it visible
      addToCartButton.isEnabled = true //PB ep69 2mins
      addToCartButton.alpha = 1.0 //PB ep69 2mins
      
      //Product info
      manufacturerLabel.text = product.manufacturer?.name //PB ep69 3mins this manufacturer is coming as the relationship between the Product entity and Manufacturer entity
      productNameLabel.text = product.name //PB ep69 4mins
      userRating.rating = Int(product.rating) //PB ep69 4mins
      
//      let listPriceAttributedString = NSAttributedString(string: product.regularPrice.currencyFormatter, attributes: [NSAttributedString.Key.strikethroughStyle: 1]) //PB ep69 5-6mins we will be putting a strikethrough in our list price to show that buyer will not be paying for it //in order to have the strikethrough effect, we will be using the NSAttributed string //pass the string and give attributes
//      listPriceLabel.attributedText = listPriceAttributedString //PB ep69 7mins label.attributedText instead of just .text
      dealPriceLabel.text = product.salePrice.currencyFormatter //PB ep69 7mins
//      priceSavedDollarLabel.text = (product.regularPrice - product.salePrice).currencyFormatter //PB ep69 8mins the dollar value will be regular price - sale price
      
//      let percentSave = ((product.regularPrice - product.salePrice) / product.regularPrice).percentFormatter //PB ep69 8-10mins calculate how many percent user is saving //with percentFormatter we created in our Double+extension
//      priceSavedPercentLabel.text = percentSave //PB ep69 10mins
      
      //so we're going to check the product availability before we can set whether it is instock
      if product.quantity > 0 { //PB ep69 11mins
         qtyLeftLabel.isHidden = false //PB ep69 13mins unhide it
         sizeButton.alpha = 1
         addToCartButton.setTitle("add to cart: 1", for: .normal)
//         inStockLabel.textColor = UIColor().pirateBay_green() //PB ep69 12mins
//         inStockLabel.text = "In Stock" //PB ep69 12mins we'll say it is in stock unless it is less than 5
         let quantity = product.quantity
         if quantity == 1 {
            qtyLeftLabel.textColor = .red
            qtyLeftLabel.text = "Last One!"
         }
         if quantity < 13 { //PB ep69 13mins if quantity is less than 5 then we start showing how much is left, else just say it is in stock
//            let qtyLeftString = product.quantity == 1 ? "item" : "items" //PB ep69 14mins if we only have one, then we will have item not items
//            let qtyText = product.quantity == 1 ? "Last One!" : "\(quantity) left"
            qtyLeftLabel.text = "\(quantity) left" //PB ep69 14mins meaning Only 2 items left or Only 1 item left
         } else {
            qtyLeftLabel.text = "12+ left"
         }
         
      } else { //PB ep69 14mins if quantity = 0
//         inStockLabel.textColor = .red //PB ep69 15mins
//         inStockLabel.text = "Currently Unavailable"
//
//         quantityButton.setTitle("Quantity: 0", for: .normal) //PB ep69 15mins
//         quantityButton.isEnabled = false //PB ep69 15mins
//         quantityButton.alpha = 0.5 //PB ep69 16mins make the button slightly dim
//         qtyLeftLabel.isHidden = true
         sizeButton.alpha = 0
         addToCartButton.isEnabled = false //PB ep69 16mins
         addToCartButton.setTitleColor(.darkGray, for: .normal)
         addToCartButton.backgroundColor = .white
         addToCartButton.layer.borderColor = UIColor.darkGray.cgColor
         addToCartButton.setTitle("sold out", for: .normal)
         addToCartButton.alpha = 0.8 //PB ep69 16mins
      }
      
      descriptionLabel.text = product.summary
      
      if let images = product.productImages { //PB ep69 16mins work on the image //we will check wether product has images or not //productImages which is coming from one to many relationship, we can see that data type is NSSet //so we want to comfort this to an array that will allow us to loop through all the images available
         let allImages = images.allObjects as! [ProductImage] //PB ep69 17mins confort this NSSet to an array images is array of any. Now we need to convert this array of any to an array of ProductImage array
         if let mainImage = allImages.first { //PB ep69 18mins get the first image as the mainImage
            productImageView.image = Utility.image(withName: mainImage.name, andType: "png") //PB ep69 19mins pass in our image
         }
         
      }
      
   }
   
   
}
