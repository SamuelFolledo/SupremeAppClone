//
//  DetailSummaryView.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 11/27/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit


public class DetailSummaryView: UIView {
   
   
   @IBOutlet weak var colorsCollectionView: UICollectionView!
   @IBOutlet weak var productsCollectionView: UICollectionView!
   
   @IBOutlet weak var colorsScrollView: UIScrollView!
   @IBOutlet weak var productsScrollView: UIScrollView!
   
   
   @IBOutlet weak var manufacturerLabel: UILabel! //PB ep68 7mins since conte
   
   @IBOutlet weak var productNameLabel: UILabel! //PB ep68 7mins
   @IBOutlet weak var dealPriceLabel: UILabel! //PB ep68 7mins
   @IBOutlet weak var qtyLeftLabel: UILabel! //PB ep68 7mins
   @IBOutlet weak var sizeButton: UIButton!
   @IBOutlet weak var descriptionLabel: UILabel!
   @IBOutlet weak var addToCartButton: UIButton! //PB ep68 7mins
   @IBOutlet weak var productImageView: UIImageView! //PB ep68 7mins
   @IBOutlet weak var userRating: UserRating! //PB ep68 7mins
   
   
//MARK: Properties
//   var colorsCollection = [Product]()
//   var productsCollection = [Product]()
   
   var buttonContainerView: UIView? //PB ep70 2mins containerView for our buttons
   var arrayButtons = [UIButton]() //PB ep70 1mins array of buttons
   
   
   
   override init(frame: CGRect) { //PB ep68 8mins because we subclass the UIView, we need to override the initialization of the UIView
      super.init(frame: frame) //PB ep68 9mins
      
      
   }
   
   required init?(coder aDecoder: NSCoder) { //PB ep68 9mins the other required method
      super.init(coder: aDecoder) //PB ep68 9mins
      
      
   }
   
   internal func updateView(with product: Product) { //PB ep68 10mins
   
//      guard let detailView = detailView else { return }
//      print("THE SELECTED PRODUCT's name IS = \(String(describing: product.name))")
      
//      colorsScrollView.delegate = self
//      productsScrollView.delegate = self
//
//      colorsCollectionView.delegate = self
//      colorsCollectionView.dataSource = self
//
//      productsCollectionView.delegate = self
//      productsCollectionView.dataSource = self
      
      //make sure no previous still exists in the currentView
      buttonContainerView?.removeFromSuperview() //PB ep70 23mins this guarantees that the buttonContainerView will be reset
      
      qtyLeftLabel.textColor = .black
      
      addToCartButton.layer.borderWidth = 1.5
      addToCartButton.layer.borderColor = UIColor.clear.cgColor
      addToCartButton.layer.cornerRadius = 5
      addToCartButton.backgroundColor = .red
      addToCartButton.setTitleColor(.white, for: .normal)
      
      sizeButton.layer.borderWidth = 1.5
      sizeButton.layer.borderColor = UIColor.darkGray.cgColor
      sizeButton.layer.cornerRadius = 5
      sizeButton.alpha = 0
      
      addToCartButton.isEnabled = true //PB ep69 2mins
      addToCartButton.alpha = 1.0 //PB ep69 2mins
      
      //Product info
      manufacturerLabel.text = product.manufacturer?.name //PB ep69 3mins this manufacturer is coming as the relationship between the Product entity and Manufacturer entity
      productNameLabel.text = product.name //PB ep69 4mins
      userRating.rating = Int(product.rating) //PB ep69 4mins
      
      dealPriceLabel.text = product.salePrice.currencyFormatter //PB ep69 7mins
      
      //so we're going to check the product availability before we can set whether it is instock
      if product.quantity > 0 { //PB ep69 11mins
         qtyLeftLabel.isHidden = false //PB ep69 13mins unhide it
         sizeButton.alpha = 1
         addToCartButton.setTitle("add to cart: 1", for: .normal)
         
         let quantity = product.quantity
         if quantity == 1 {
            qtyLeftLabel.textColor = .red
            qtyLeftLabel.text = "Last One!"
         }
         if quantity < 13 { //PB ep69 13mins if quantity is less than 5 then we start showing how much is left, else just say it is in stock
         
            qtyLeftLabel.text = "\(quantity) left" //PB ep69 14mins meaning Only 2 items left or Only 1 item left
         } else {
            qtyLeftLabel.text = "12+ left"
         }
      
      } else if product.quantity == 0 || product.quantity < 0 { //PB ep69 14mins if quantity = 0
         qtyLeftLabel.text = "Out of stock!"
         qtyLeftLabel.textColor = .red
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
         
         let imageCount = allImages.count //PB ep70 0mins count all the images we have in that product, so we know how many array of buttons to create
         //         var arrayButtons = [UIButton]() //PB ep70 1mins array of buttons
         buttonContainerView = UIView() //PB ep70 2mins initialize the buttonContainerView
         let containerHeight = imageCount * 50 + (imageCount - 1) * 10 //PB ep70 19mins
         let xx: Int = Int(self.frame.width - (self.frame.width / 5) + self.frame.width / 40)
         self.buttonContainerView!.frame = CGRect(x: xx, y: Int(productImageView.frame.minY + 55), width: 50, height: containerHeight) //PB ep70 20mins will have 20 spaces on the left, and right underneath productImageView
         
         for x in 0..<imageCount { //PB ep70 2mins loop base on the number of images we have
            let image = Utility.image(withName: allImages[x].name, andType: "png") //PB ep70 3mins image we will have to our buttons
            let buttonImage = image?.resizeImage(newHeight: 40.0) //PB ep70 4mins to have the image resize properly we need an extension //PB ep70 8mins finished
            
            let button = UIButton() //PB ep70 8mins initialize button
            button.centerVertically(padding: 2)
            
            button.setTitle(allImages[x].name, for: .normal) //PB ep70 8mins
            button.setTitleColor(.clear, for: .normal)
            
            button.imageView?.contentMode = .scaleAspectFit //PB ep70 9mins
            button.setImage(buttonImage, for: .normal) //PB ep70 9mins
            button.imageEdgeInsets = UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0) //PB ep70 10mins image is centered in the button itself
            button.contentMode = .center //PB ep70 10mins
            button.layer.borderWidth = 1 //PB ep70 11mins
            button.layer.borderColor = UIColor.lightGray.cgColor //PB ep70 11mins
            button.layer.cornerRadius = 5 //PB ep70 11mins
            
            //now we need to put the button's coordinates
            if x == 0 { //PB ep70 11mins
               button.frame = CGRect(x: 0, y: 0, width: 50.0, height: 50.0) //PB ep70 12mins all of these buttons will be inserted in the buttonContainerView, that is why 0,0 will be on the top left
               button.layer.borderWidth = 1
               button.layer.borderColor = UIColor.red.cgColor
            } else { //PB ep70 13mins
               button.frame = CGRect(x: arrayButtons[x-1].frame.minX, y: arrayButtons[x-1].frame.maxY + 10, width: 50.0, height: 50.0) //PB ep70 13-16mins to get the x we the arrayButtons[x-1] because we need to get the previous buttons's coordinates, then .frame.maxX to get the furthest X of the previous's button and lastly + 10spaces in between. For y = arrayButtons[x-1].frame.minY, it is the same thing but this time, we get the minimum possible y of the previous button, which allows this method to be reusable even if we go to a new line of buttons
            }
            arrayButtons.append(button) //PB ep70 16mins add it to array
            
            //PB ep70 16mins now we want to show a larger image once button is tapped, we'll create a method for it
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside) //PB ep70 18mins
            buttonContainerView?.addSubview(button) //PB ep70 18mins we still need to determine the size of containerView
         }
         
//         self.colorsCollectionView.reloadData()
//         self.productsCollectionView.reloadData()
//         addSubview(buttonContainerView!) //PB ep70 21mins add it to our DetailSummaryView, remember to reset this view when we switched products
      }
   } //end of updateProductDetailView
   
   
   
   @objc func buttonAction (_ sender: UIButton) { //PB ep70 16mins sender is the uibutton itself
      for button in arrayButtons { //clear the button's borders
         button.layer.borderWidth = 2
         button.layer.borderColor = UIColor.clear.cgColor
      }
      
      //guard let detailView = detailView else { return }
      if let imageName = sender.currentTitle { //PB ep70 16mins now we need to get the imageName from the button being tapped to display the larger image
         sender.layer.borderColor = UIColor.red.cgColor
         
         let image = Utility.image(withName: imageName, andType: "png") //PB ep70 16mins get the image from imageName
         productImageView.image = image //PB ep70 17mins update our productImageView
         productImageView.contentMode = .scaleAspectFit //PB ep70 17mins
      }
   }
   
   
   @IBAction func sizeQuantityButtonTapped(_ sender: Any) {
      
      
      
   }
   
   @IBAction func addToCartButtonTapped(_ sender: Any) {
      
   }
}
