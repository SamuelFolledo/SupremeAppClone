//
//  ProductService.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 11/21/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import Foundation
import CoreData //PB ep11 4mins

struct ProductService { //PB ep11 4mins
   
   static var managedObjectContext = CoreDataStack().persistentContainer.viewContext //PB ep11 5mins we used static because we'll create a static func to access our service
   
   internal static func productsCategory(category type: String) -> [Product] { //PB ep11 6mins this method takes a category and returns an array of Product entity //internal access modifier which will allow access from within the app from outside of ProductService class itself //static allow us to call this product function without the need to create an instance
      let request: NSFetchRequest<Product> = Product.fetchRequest() //PB ep11 6mins
      request.predicate = NSPredicate(format: "type == %@", type) //PB ep11 7mins we //predicate = The predicate instance constrains the selection of objects the NSFetchRequest instance is to fetch. //NSPredicate = A definition of logical conditions used to constrain a search either for a fetch or for in-memory filtering. //format is type equal the value being passed by the input argument which is type
      
      do { //PB ep11 8mins
         
         let products = try self.managedObjectContext.fetch(request) //PB ep11 9mins we create the products, try and execute the request. The result of this product is a form of an array of products
         return products
         
      } catch let error as NSError { //PB ep11 8mins
         fatalError("Error in getting product list \(error.localizedDescription)") //PB ep11 8mins
      }
   }
   
   internal static func productsColors(productName name: String) -> [Product] { //PB ep11 6mins this method takes a category and returns an array of Product entity //internal access modifier which will allow access from within the app from outside of ProductService class itself //static allow us to call this product function without the need to create an instance
      let request: NSFetchRequest<Product> = Product.fetchRequest() //PB ep11 6mins
      request.predicate = NSPredicate(format: "name == %@", name) //PB ep11 7mins we //predicate = The predicate instance constrains the selection of objects the NSFetchRequest instance is to fetch. //NSPredicate = A definition of logical conditions used to constrain a search either for a fetch or for in-memory filtering. //format is type equal the value being passed by the input argument which is type
      
      do { //PB ep11 8mins
         
         let products = try self.managedObjectContext.fetch(request) //PB ep11 9mins we create the products, try and execute the request. The result of this product is a form of an array of products
         return products
         
      } catch let error as NSError { //PB ep11 8mins
         fatalError("Error in getting product list \(error.localizedDescription)") //PB ep11 8mins
      }
   }
   
   
   
   internal static func browse() -> [Product] { //PB ep64 2mins
      let request: NSFetchRequest<Product> = Product.fetchRequest() //PB ep64 2mins request from CoreData. type NSFetchRequest with a paramter of the Product, and set the FetchRequest to the Product entity
      
      do { //PB ep64 2mins
         let products = try self.managedObjectContext.fetch(request) //PB ep64 3mins execute our request
         return products //PB ep64 4mins return products which is already in a form of an array of Products
         
      } catch let error as NSError { //PB ep64 2mins
         fatalError("Error in getting all products \(error.localizedDescription)") //PB ep64 3mins
      }
      
   }
   
   
}

