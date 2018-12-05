//
//  DetailSummary.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 12/4/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

public struct DetailSummary {
   
   public var manufacturer: String //PB ep68 7mins since conte
   
   public var productName: String //PB ep68 7mins
   //   @IBOutlet weak var listPriceLabel: UILabel! //PB ep68 7mins
   public var dealPrice: String //PB ep68 7mins
   //   @IBOutlet weak var priceSavedDollarLabel: UILabel! //PB ep68 7mins
   //   @IBOutlet weak var priceSavedPercentLabel: UILabel! //PB ep68 7mins
   //   @IBOutlet weak var inStockLabel: UILabel! //PB ep68 7mins
   public var qtyLeft: String //PB ep68 7mins
//   public var sizeButton: UIButton!
   public var description: String
   //   @IBOutlet weak var quantityButton: UIButton! //PB ep68 7mins
//   public var addToCartButton: UIButton! //PB ep68 7mins
   public var productImage: UIImage //PB ep68 7mins
//   public var userRating: UserRating! //PB ep68 7mins
   
   
   //MARK: Properties
   public var colorsCollection = [Product]()
   public var productsCollection = [Product]()
   
   public var buttonContainerView: UIView? //PB ep70 2mins containerView for our buttons
   
}
