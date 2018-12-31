//
//  ShoppingCart.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 12/30/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import Foundation

//@objc protocol ShoppingCartDelegate: class { //PB ep81 0mins class type protocol, this delegate will have 2 functions
//   func updateTotalCartItem() //PB ep81 1mins
//   @objc optional func confirmRemoval(forProduct product: Product, itemIndexPath: IndexPath) //PB ep81 1-2mins EXAMPLE of an optional delegate function //IMPORTANT to add @objc protocol instead of regular protocol
//}



class ShoppingCart { //PB ep75 0mins created as a singleton, meaning only one instant can exist at any given time. So we are not reinitializing this cart as well as keep track
   
   var items = [(product: Product, quantity: Int)]() //PB ep75 3mins items will be an array of tupples as they can be more than 1 item that must have a product and a quantity
   
   static let sharedInstance = ShoppingCart() //PB ep75 1mins thiw will initialize this shopping cart
   private init() {} //PB ep75 2mins this prevents reinitialization. This prevents us to invoke the ShoppingCart.init(), the access of this class is only through sharedInstance
   
   
   //add
   internal func add(product: Product, quantity: Int) { //PB ep75 2mins
      if let index = find(product: product) { //PB ep75 9mins if it exists in the cart, add the qty to the current qty//PB ep75 5mins check if we have that product in our items array already //we need to check if user edits the quantity, instead of adding a new product and quantity, we should just edit the quantity
         let newQty = items[index].quantity + quantity //PB ep75 10mins
         items[index] = (product, newQty) //PB ep75 10mins the item which contains the index of the product we found will have its quantity incremented instead
         
      } else { //PB ep75 10mins if product is not in the items array...
         items.append((product, quantity)) //PB ep75 4mins add the product and quantity passed in to our property
      }
   }
   
   
   //update
   internal func update(product: Product, quantity: Int) { //PB ep75 12mins update method for our ShoppingCart
      if let index = find(product: product) { //PB ep75 12mins
         items[index] = (product, quantity) //PB ep75 13mins product is the product we want to update, and the quantity will be the new quantity
      }
   }
   
   
   //delete
   internal func delete(product: Product) { //PB ep75 13mins, we will not need quantity as we will be removing this frm our array
      if let index = find(product: product) { //PB ep75 13mins
         items.remove(at: index) //PB ep75 14mins
      }
   }
   
   
   internal func totalItem() -> Int { //PB ep75 14mins this method will return Int of total items we have in our array
      var totalItem = 0 //PB ep75 15mins
      for item in items { //PB ep75 15mins
         totalItem += item.quantity //PB ep75 15mins increment the quantities for each item
      }
      return totalItem //PB ep75 15mins
   }
   
   
   //totalCost
   internal func totalItemCost() -> Double { //PB ep75 16mins
      var totalCost: Double = 0.0 //PB ep75 16mins
      for item in items { //PB ep75 16mins
         totalCost += Double(item.quantity) * item.product.salePrice //PB ep75 17mins multiply each item's salePrice by its quantity. salePrice is from our DataModel
      }
      return totalCost //PB ep75 17mins
   }
   
   
   //find
   private func find(product: Product) -> Int? { //PB ep75 6-7mins this method will take a product and search our items property and returns the Int index that product it is at in the items, it could also return nil
      let index = items.firstIndex(where: { $0.product == product }) //PB ep75 7-8mins $0 represents each items inside the array thats getting loop. SO here we check if our items has a .product equal to our passed in product
      
      return index //PB ep75 8mins return it which can be an optional
   }
   
}
