//
//  CustomerService.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 2/27/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import Foundation
import CoreData //PB ep84 0mins

enum CreditCardType: String { //PB ep91 14mins enum which will identify the card type the customer is using
	case Visa = "visa" //PB ep91 14mins
	case MC = "mastercard" //PB ep91 15mins
	case Amex = "amex" //PB ep91 15mins
	case Discover = "discover" //PB ep91 15mins
	case Unknown = "unknown" //PB ep91 15mins
}

struct CustomerService { //PB ep84 1mins
	
	static var managedObjectContext = CoreDataStack().persistentContainer.viewContext //PB ep84 4mins get the CoreDataStack class's persisten container
	
	static internal func verify(username: String, password: String) -> Customer? { //PB ep84 1mins verify function for customer. This method accepts username and password and return the Customer entity if there is a customer that match with what we have in our CoreData, else return nil
		let request: NSFetchRequest<Customer> = Customer.fetchRequest() //PB ep84 2mins
		request.predicate = NSPredicate(format: "email = %@ AND password = %@", username, password) //PB ep84 3mins request predicate.
		
		do {
			let result = try managedObjectContext.fetch(request) //PB ep84 5mins
			
			if result.count > 0 { //PB ep84 6mins if there is an object in our result...
				return result.first //PB ep84 6mins return the first
			}
			
			return nil //PB ep84 6mins no result then return nil
			
		} catch let error as NSError { //PB ep84 4mins
			print("Error verifying customer login: \(error.localizedDescription)") //PB ep84 4mins
			return nil //PB ep84 5mins
		}
	}
	
	
	static internal func addCustomer(name: String, email: String, phone: String) -> Customer { //PB ep85 24mins register method
		let customer = Customer(context: managedObjectContext) //PB ep85 25mins instantiate the Customer entity and call managedObectContext
		customer.name = name //PB ep85 25mins
		customer.email = email //PB ep85 26mins
		customer.phone = phone
//		customer.password = password //PB ep85 26mins
		
		do { //PB ep85 26mins now we can save the customer in do catch block
			try managedObjectContext.save() //PB ep85 27mins now save and return customer
			return customer //PB ep85 27mins
			
		} catch let error as NSError { //PB ep85 26mins
			fatalError("Error create a new customer: \(error.localizedDescription)") //PB ep85 26mins
		}
		
	}
	
	static func addressList(forCustomer customer: Customer) -> [Address] { //PB ep87 9mins this method takes a Customer and return an array of Address for this customer
		let addresses = customer.address?.mutableCopy() as! NSMutableSet //PB ep87 10mins since customer has a relationship to address. But the result will be an immutable NSSet that is why we need to make it mutable
		return addresses.allObjects as! [Address] //PB ep87 11mins now return it, but convert this NSMutableSet to an array
	}
	
	
	static func addAddress(forCustomer customer: Customer, address1: String, city: String, state: String, zip: String, phone: String) -> Address { //PB ep90 6mins takes a customer and addresses and return an Address entity
		let address = Address(context: managedObjectContext) //PB ep90 7mins reference to Address entity
		address.address1 = address1
//		address.address2 = address2
		address.city = city
		address.state = state
		address.zip = zip
		
		let addresses = customer.address?.mutableCopy() as! NSMutableSet //PB ep90 9mins Customer has a one to many relationship with Address. It is an NSSet so we need to convert it so we can update it
		
		if addresses.contains(address) { //check if we already have that address, then just return
			return address
		} else {
			addresses.add(address) //PB ep90 10mins now we can add the new address to our addresses
			
			customer.address = addresses.copy() as? NSSet //PB ep90 10mins now put this addresses back to the Customer entity
			customer.phone = phone //PB ep90 11mins also add the phone
			
			do { //PB ep90 11mins now we save the state of Customer and Address entity to the CoreData
				try managedObjectContext.save() //PB ep90  save them
				return address //PB ep90 25mins
				
			} catch let error as NSError { //PB ep90 11mins
				fatalError("Error adding customer address: \(error.localizedDescription)") //PB ep90 12mins
			}
		}
	}
	
	
	static func addCreditCard(forCustomer customer: Customer, nameOnCard: String, cardNumber: String, expMonth: Int, expYear: Int, cvv: Int) -> CreditCard { //PB ep91 16mins method to add CreditCard
		let creditCard = CreditCard(context: managedObjectContext) //PB ep91 17mins credit card reference to the entity
		
		creditCard.nameOnCard = nameOnCard //PB ep91 17mins
		creditCard.cardNumber = cardNumber //PB ep91 17mins
		creditCard.expMonth = Int16(expMonth) //PB ep91 18mins make sure it is at Int16
		creditCard.expYear = Int16(expYear) //PB ep91 18mins
		
		switch cardNumber.first { //PB ep91 19mins
		case "3": //PB ep91 19mins
			creditCard.type = CreditCardType.Amex.rawValue //PB ep91 19mins if cardNumber begins with 3, the creditCard type will be the CreditCardType.Amex's rawValue
		case "4":
			creditCard.type = CreditCardType.Visa.rawValue //PB ep91 20mins
		case "5": //PB ep91 20mins
			creditCard.type = CreditCardType.MC.rawValue //PB ep91 20mins
		case "6": //PB ep91 20mins
			creditCard.type = CreditCardType.Discover.rawValue //PB ep91 20mins
		default: //PB ep91 21mins
			creditCard.type = CreditCardType.Unknown.rawValue //PB ep91 21mins
		}
		
		let creditCards = customer.creditCard?.mutableCopy() as! NSMutableSet //PB ep91 21mins just like with the address, the customer can have multiple credit cards
		creditCards.add(creditCard) //PB ep91 22mins add the new card to the existing cards the customer has
		
		customer.creditCard = creditCards.copy() as? NSSet //PB ep91 23mins save creditcard to the customer entity
		
		do { //PB ep91 23mins now we can save it
			try managedObjectContext.save() //PB ep91 23mins
			return creditCard //PB ep91 23mins
		} catch let error as NSError { //PB ep91 23mins
			fatalError("Error adding credit card: \(error.localizedDescription)") //PB ep91 24mins
		}
	}
	
}

