//
//  AppDelegate.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 11/20/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
import CoreData //PB ep 9 0mins

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

   var window: UIWindow?
   
   var coreDataStack = CoreDataStack()
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      // Override point for customization after application launch.
      
      
      deleteProducts() //PB ep10 0mins this delete products so we can refresh and load products again when the app starts to avoid duplications
      loadProducts() //PB ep9 38mins
//      let listsVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "secondVC") as! ProductListsViewController
//      let detailsVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "thirdVC") as! ProductDetailsViewController
//      listsVC.productDetailsController = detailsVC
      
      return true
   }

   func applicationWillResignActive(_ application: UIApplication) {
      // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
      // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
   }

   func applicationDidEnterBackground(_ application: UIApplication) {
      // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
      // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   }

   func applicationWillEnterForeground(_ application: UIApplication) {
      // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
   }

   func applicationDidBecomeActive(_ application: UIApplication) {
      // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   }

   func applicationWillTerminate(_ application: UIApplication) {
      // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
   }

   
   
//deleteProducts
   private func deleteProducts() { //PB ep10 1mins by having delete and load products during development, it will allow us to reset what we have in the Products database and get the newest products back
      let managedObjectContext = coreDataStack.persistentContainer.viewContext //PB ep10 1mins
      
      let productRequest: NSFetchRequest<Product> = Product.fetchRequest() //PB ep10 2mins create a request object for each Entities and initialize the fetchRequest for this Product entity
      let manufacturerRequest: NSFetchRequest<Manufacturer> = Manufacturer.fetchRequest() //PB ep10 3mins
      let productInfoRequest: NSFetchRequest<ProductInfo> = ProductInfo.fetchRequest() //PB ep10 3mins
      let productImageRequest: NSFetchRequest<ProductImage> = ProductImage.fetchRequest() //PB ep10 3mins
      
      var deleteRequest: NSBatchDeleteRequest //PB ep10 3mins create the delete requeset
      
      do { //PB ep10 4mins delete the entities, which can be done in do try catch block
         deleteRequest = NSBatchDeleteRequest(fetchRequest: productRequest as! NSFetchRequest<NSFetchRequestResult>) //PB ep10 4mins get the delete request
         try managedObjectContext.execute(deleteRequest) //PB ep10 5mins execute the request
         
         deleteRequest = NSBatchDeleteRequest(fetchRequest: productRequest as! NSFetchRequest<NSFetchRequestResult>) //PB ep10 6mins
         try managedObjectContext.execute(manufacturerRequest) //PB ep10 6mins
         
         deleteRequest = NSBatchDeleteRequest(fetchRequest: productRequest as! NSFetchRequest<NSFetchRequestResult>) //PB ep10 6mins
         try managedObjectContext.execute(productInfoRequest) //PB ep10 6mins
         
         deleteRequest = NSBatchDeleteRequest(fetchRequest: productRequest as! NSFetchRequest<NSFetchRequestResult>) //PB ep10 6mins
         try managedObjectContext.execute(productImageRequest) //PB ep10 6mins
         
      } catch {} //PB ep10 4mins do nothing
   }
   
   
//loadProducts
   private func loadProducts() { //PB ep 9 1mins this method is responsible to Parse data from JSON and then insert to our Data model
      let managedObjectContext = coreDataStack.persistentContainer.viewContext  //PB ep 9 1mins get the managedObjectContext from our CoreDataStack
      let url = Bundle.main.url(forResource: "clothesProducts", withExtension: "json") //PB ep 9 2mins get reference to our JSON file and store it in type url
      if let url = url { //PB ep 9 2mins unwrap url, if exist then get the data out of that url
         let data = try? Data(contentsOf: url) //PB ep 9 3mins if url is not nil and we can get the data out of it, then place it to data constant. If nil then its just going to write a nil value which is why there is a ? in try
         do { //PB ep 9 3mins
            guard let data = data else { return } //PB ep 9 5mins data hsould not be nil
            
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary //PB ep 9 5mins out of the data, we get our jsonResult which requires a try statement. Pass in our data and mutableContainer option and cast it as NSDictionary
            let jsonArray = jsonResult.value(forKey: "products") as! NSArray //PB ep 9 6mins get the array out of it. The forkey is the root of the product.json
            for json in jsonArray { //PB ep 97mins loop through our array
               let productData = json as! [String: Any] //PB ep 9get the data from json, and result is type Dictionary with String value is Any as it can be a double or stirng etc.
               //PB ep 9 8mins//Now we check if the product doesnt have the productId or the name or the type, if not then stop as they are required
               guard let productId = productData["id"] else { return } //PB ep 9 8mins check id of each product
               guard let name = productData["name"] else { return } //PB ep 9 9mins
               guard let type = productData["type"] else { return } //PB ep 9 9mins
               
               //now we can start populating our Products table
               let product = Product(context: managedObjectContext) //PB ep 9 10mins get our Entity and pass our managedObjectContext
               product.id = productId as? String //PB ep 9 10mins for first attribute, capture the id
               product.name = name as? String //PB ep 9 10mins
               product.type = type as? String //PB ep 9 10mins
               
               //PB ep 9 11-14mins //extract each of the element in product json
               if let regularPrice = productData["regularPrice"] { //PB ep 9 11mins
                  product.regularPrice = (regularPrice as? Double)! //PB ep 9 11mins
               }
               if let salePrice = productData["salePrice"] { //PB ep 9 11mins
                  product.salePrice = (salePrice as? Double)! //PB ep 9 11mins
               }
               if let quantity = productData["quantity"] { //PB ep 9 11mins
                  product.quantity = (quantity as AnyObject).int16Value //PB ep 9 11mins since quantity and rating is type integer 16 in our Entity, we have to unwrap like this
               }
               if let rating = productData["rating"] { //PB ep 9 11mins
                  product.rating = (rating as AnyObject).int16Value //PB ep 9 11mins
               }
               
               let manufacturer = Manufacturer(context: managedObjectContext) //PB ep9 14mins now we capture the manufacturer Entity
               manufacturer.id = (productData["manufacturerId"] as AnyObject).int16Value //PB ep9 15mins
               manufacturer.name = productData["manufacturerName"] as? String //PB ep9 15mins
               
               product.manufacturer = manufacturer //PB ep9 16mins now that we have the manufacturer, we want to store that manufacturer information in our product Entity, this is what the relationship is for. By doin this, we link the product entity with the manufacturer entity
               
               //PB ep9 16mins now we start storing images for each product. In order to start storing these images, we create a reference of the product images that we have under our product entity
               let productImages = product.productImages?.mutableCopy() as! NSMutableSet //PB ep9 17mins if you notice propduct.productImages data type is a NSSet, which is not mutable. So to store images that comes from clothesProduct.json we need to confirm this NSSet to a mutable set, by using mutableCopy() as! NSMutableSet
               var mainImageName: String? //PB ep9 17mins
               
               if let imageNames = productData["images"] { //PB ep9 18mins check if json has the images or not
                  for imageName in imageNames as! NSArray { //PB ep9 18mins cast it as NSArray so we can loop through it
                     let productImage = ProductImage(context: managedObjectContext) //PB ep9 19mins no we need to instantiate our productImage to be able to store these image coming frm the .json
                     
                     //created Utility.swift and String+extension before we continued
                     let currentImageName = imageName as? String //PB ep9 26mins
                     let currentImage = Utility.image(withName: currentImageName, andType: ".png") //PB ep9 26mins
                     
                     //PB ep9 27mins //now that we have currentImage, we can store the image from ProductImage Entity, and our image in the Entity is Binary Data data type
                     productImage.image = NSData.init(data: currentImage!.jpegData(compressionQuality: 0.8)!) as Data //PB ep9 28mins convert the image to to a JPEG with some compression
                     productImage.name = currentImageName //PB ep9 28mins
                     
                     //PB ep9 28mins in the Product entity, we'll also store that main imageName to the Product entity
                     if mainImageName == nil && currentImageName?.contains("1") == true { //PB ep9 29mins if mainImageNil is still nil and our currentImageName contains a 1, since some images will have 1-5... //our mainImage will be the imageName with 1
                        mainImageName = currentImageName //PB ep9 29mins
                     }
                     productImages.add(productImage) //PB ep9 29mins add the productImage entity to our mutable productImages NSSet
                  }
                  
                  product.productImages = productImages.copy() as? NSSet //PB ep9 29mins so after the looping is done we want to store those productImages and associate those images with our product entity //PB ep9 30mins because the productImages is an NSMutableSet, we need to make it an NSSet again by copying it and converting back to NSSet
               }
               product.mainImage = mainImageName //PB ep9 30mins then we store the mainImage only
               
               //Product Summary
               if let summary = productData["summary"] { //PB ep9 30mins
                  product.summary = summary as? String //PB ep9 31mins
               }
               
               //Product Info
               let productInfo = product.productInfo?.mutableCopy() as! NSMutableSet //PB ep9 31mins similar to images, we need to convert from NSSet to NSMutableSet
               
               if let description1 = productData["description1"] {//PB ep9 31mins now we have each product's description, some products have 1 or 1-3 description, we have to check if its nil or not
                  let temp = ProductInfo(context: managedObjectContext) //PB ep9  //PB ep9 32mins if description1 is not nil, then we create a reference to the ProductInfo entity and store it in a temporary constant
                  temp.info = description1 as? String //PB ep9 32mins assign temp.info's info
                  temp.type = "description" //PB ep9 32mins
                  productInfo.add(temp) //PB ep9 33mins
               } //PB ep9 33mins same thing for description 2 and 3
               
               if let description2 = productData["description2"] { //PB ep9 33mins
                  let temp = ProductInfo(context: managedObjectContext) //PB ep9 33mins
                  temp.info = description2 as? String //PB ep9 33mins
                  temp.type = "description" //PB ep9 33mins
                  productInfo.add(temp) //PB ep9 33mins
               }
               
               if let description3 = productData["description3"] { //PB ep9 33mins
                  let temp = ProductInfo(context: managedObjectContext) //PB ep9 33mins
                  temp.info = description3 as? String //PB ep9 33mins
                  temp.type = "description" //PB ep9 33mins
                  productInfo.add(temp) //PB ep9 33mins
               }
               
               //PB ep19 34mins - 37mins //to capture other product info like weight, dimension etc...
               if let weight = productData["weight"] { //PB ep9 33mins
                  let temp = ProductInfo(context: managedObjectContext) //PB ep9 33mins
                  temp.title = "Item Weight"
                  temp.info = weight as? String //PB ep9 33mins
                  temp.type = "specs" //PB ep9 33mins
                  productInfo.add(temp) //PB ep9 33mins
               }
               
               if let dimension = productData["dimension"] { //PB ep9 33mins
                  let temp = ProductInfo(context: managedObjectContext) //PB ep9 33mins
                  temp.title = "Product Dimension"
                  temp.info = dimension as? String //PB ep9 33mins
                  temp.type = "specs" //PB ep9 33mins
                  productInfo.add(temp) //PB ep9 33mins
               }
               
               if let ageGroup = productData["ageGroup"] { //PB ep9 33mins
                  let temp = ProductInfo(context: managedObjectContext) //PB ep9 33mins
                  temp.title = "Age Group"
                  temp.info = ageGroup as? String //PB ep9 33mins
                  temp.type = "specs" //PB ep9 33mins
                  productInfo.add(temp) //PB ep9 33mins
               }
               
               if let modelNumber = productData["modelNumber"] { //PB ep9 33mins
                  let temp = ProductInfo(context: managedObjectContext) //PB ep9 33mins
                  temp.title = "Model Number"
                  temp.info = modelNumber as? String //PB ep9 33mins
                  temp.type = "specs" //PB ep9 33mins
                  productInfo.add(temp) //PB ep9 33mins
               }
               
               //for DVDs
               if let format = productData["format"] { //PB ep9 33mins
                  let temp = ProductInfo(context: managedObjectContext) //PB ep9 33mins
                  temp.title = "Format"
                  temp.info = format as? String //PB ep9 33mins
                  temp.type = "specs" //PB ep9 33mins
                  productInfo.add(temp) //PB ep9 33mins
               }
               
               if let language = productData["language"] { //PB ep9 33mins
                  let temp = ProductInfo(context: managedObjectContext) //PB ep9 33mins
                  temp.title = "Language"
                  temp.info = language as? String //PB ep9 33mins
                  temp.type = "specs" //PB ep9 33mins
                  productInfo.add(temp) //PB ep9 33mins
               }
               
               if let region = productData["region"] { //PB ep9 33mins
                  let temp = ProductInfo(context: managedObjectContext) //PB ep9 33mins
                  temp.title = "Region"
                  temp.info = region as? String //PB ep9 33mins
                  temp.type = "specs" //PB ep9 33mins
                  productInfo.add(temp) //PB ep9 33mins
               }
               
               product.productInfo = productInfo.copy() as? NSSet //PB ep9 37mins //After we get this ProductInfo, we want to relate this productInfo to a Product entity
            }
            
            coreDataStack.saveContext() //PB ep9 38mins After we parse all this info, we can save it to our DataModel //Dont forget to call our load function in our didFinishLaunchingWithOptions
            
         } catch let error as NSError { //PB ep 9 4mins
            print("Error in parsing products.json: \(error.localizedDescription)") //PB ep 9 4mins
         }
      }
   }
}

