//
//  String+extension.swift
//  FolledoEcommerceApp
//
//  Created by Samuel Folledo on 11/20/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit //PB ep9 22mins

extension String { //PB ep9 23mins
   
   func stripFileExtension() -> String { //PB ep9 23-25mins strips extension like .jpg or .png
      if self.contains("."), let index = self.firstIndex(of: ".") { //PB ep9 23mins if string contains "." //get the index of . and
         let endIndex = self.index(index, offsetBy: -1) //PB ep9 get the index before
         return String(self[...endIndex]) //PB ep9 return the string until the endIndex (removing anything "." and everything after the period)
      }
      return self //PB ep9 else if no dot then return self
   }
}
