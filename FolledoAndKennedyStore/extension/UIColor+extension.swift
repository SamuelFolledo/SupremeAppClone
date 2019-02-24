//
//  UIColor+extension.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 11/27/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit //PB ep64

extension UIColor { //PB ep64 16mins
   func pirateBay_gold() -> UIColor { //PB ep64 16mins
      return UIColor(red: 252/255.0, green: 194/255.0, blue: 0, alpha: 1.0) //PB ep64 17mins
   }
   
   func pirateBay_green() -> UIColor { //PB ep69 12mins
      return UIColor(red: 56/255.0, green: 116/255.0, blue: 8/255.0, alpha: 1.0) //PB ep69 12mins
   }
   
   
   
   
   
   convenience init(red: Int, green: Int, blue: Int) {
      assert(red >= 0 && red <= 255, "Invalid red component")
      assert(green >= 0 && green <= 255, "Invalid green component")
      assert(blue >= 0 && blue <= 255, "Invalid blue component")
      
      self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }
   
   convenience init(rgb: Int) {
      self.init(
         red: (rgb >> 16) & 0xFF,
         green: (rgb >> 8) & 0xFF,
         blue: rgb & 0xFF
      )
   }
   
}
