//
//  Double+Extension.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 11/27/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import Foundation

extension Double { //PB ep63 14mins
   var currencyFormatter: String { //PB ep63 15mins
      let formatter = NumberFormatter() //PB ep63 15mins
      formatter.numberStyle = .currency //PB ep63 15mins style is currency
      
      return formatter.string(from: NSNumber(value: self))! //PB ep63 16mins return a string with a value from self
   }
   
   var percentFormatter: String { //PB ep69 9mins
      let formatter = NumberFormatter() //PB ep69 9mins
      formatter.numberStyle = .percent //PB ep69 10mins
      
      return formatter.string(from: NSNumber(value: self))! //PB ep69 10mins
   }
   
}
