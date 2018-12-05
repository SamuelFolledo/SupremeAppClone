//
//  ProductDetailsViewController.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 11/27/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController, UIScrollViewDelegate {
   
   @IBOutlet weak var detailView: DetailSummaryView!
   
//   @IBOutlet weak var colorsCollectionView: UICollectionView!
//   @IBOutlet weak var productsCollectionView: UICollectionView!
//   
//   var colorsCollection = [Product]()
//   var productsCollection = [Product]()
//   
//   @IBOutlet weak var colorsScrollView: UIScrollView!
//   @IBOutlet weak var productsScrollView: UIScrollView!
   
   @IBOutlet weak var topLogoImageView: UIImageView!
   @IBOutlet weak var cartButton: UIButton!
   @IBOutlet weak var checkOutButton: UIButton!
   @IBOutlet weak var nextProductButton: UIButton!
   @IBOutlet weak var keepShoppingButton: UIButton!
   
//   @IBOutlet weak var detailSummaryView: DetailSummaryView!
   
   
   var timer = Timer()
   var counter: Int = 0
   
   var clothesCollection = [Product]()
   var productType = ""
   
   var productName: String = ""
   
   var selectedProduct: Product?
   
   var productIndex = 0
   var product: Product? {
      didSet {
         if let currentProduct = product {
            self.updateView(with: currentProduct)
         }
      }
   }
   
   public var detailSummary: DetailSummary?
   
//   var detailView: DetailSummaryView! {
//      guard isViewLoaded == true else { return nil }
////      let view = DetailSummaryView()
//      return (view as! DetailSummaryView)
//   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setUpViews()
      loadClothesCollection()
      
      let tap = UITapGestureRecognizer(target: self, action: #selector(handleLogoDismiss))
      self.topLogoImageView.isUserInteractionEnabled = true
      self.topLogoImageView.addGestureRecognizer(tap)
      
      
      
      print("THE SELECTED PRODUCT IS = \(product)")
//      if let currentProduct = product {
//         self.showDetail(for: currentProduct)
//      }
      
      if let product = product {
         updateView(with: product)
      }
   }
   
   func updateView(with product: Product) { //PB ep68 10mins
      
      guard let detailView = detailView else { return }
      
      detailView.colorsScrollView.delegate = self
      detailView.productsScrollView.delegate = self
      
      //make sure no previous still exists in the currentView
      detailView.buttonContainerView?.removeFromSuperview() //PB ep70 23mins this guarantees that the buttonContainerView will be reset
      
      detailView.qtyLeftLabel.textColor = .black
      
      detailView.addToCartButton.layer.borderWidth = 1.5
      detailView.addToCartButton.layer.borderColor = UIColor.clear.cgColor
      detailView.addToCartButton.layer.cornerRadius = 5
      detailView.addToCartButton.backgroundColor = .red
      detailView.addToCartButton.setTitleColor(.white, for: .normal)
      
      detailView.sizeButton.layer.borderWidth = 1.5
      detailView.sizeButton.layer.borderColor = UIColor.darkGray.cgColor
      detailView.sizeButton.layer.cornerRadius = 5
      detailView.sizeButton.alpha = 0
      
      detailView.addToCartButton.isEnabled = true //PB ep69 2mins
      detailView.addToCartButton.alpha = 1.0 //PB ep69 2mins
      
      //Product info
      detailView.manufacturerLabel.text = product.manufacturer?.name //PB ep69 3mins this manufacturer is coming as the relationship between the Product entity and Manufacturer entity
      detailView.productNameLabel.text = product.name //PB ep69 4mins
      detailView.userRating.rating = Int(product.rating) //PB ep69 4mins
      
      detailView.dealPriceLabel.text = product.salePrice.currencyFormatter //PB ep69 7mins
      
      //so we're going to check the product availability before we can set whether it is instock
      if product.quantity > 0 { //PB ep69 11mins
         detailView.qtyLeftLabel.isHidden = false //PB ep69 13mins unhide it
         detailView.sizeButton.alpha = 1
         detailView.addToCartButton.setTitle("add to cart: 1", for: .normal)
         
         let quantity = product.quantity
         if quantity == 1 {
            detailView.qtyLeftLabel.textColor = .red
            detailView.qtyLeftLabel.text = "Last One!"
         }
         if quantity < 13 { //PB ep69 13mins if quantity is less than 5 then we start showing how much is left, else just say it is in stock
            
            detailView.qtyLeftLabel.text = "\(quantity) left" //PB ep69 14mins meaning Only 2 items left or Only 1 item left
         } else {
            detailView.qtyLeftLabel.text = "12+ left"
         }
         
      } else if product.quantity == 0 || product.quantity < 0 { //PB ep69 14mins if quantity = 0
         detailView.qtyLeftLabel.text = "Out of stock!"
         detailView.qtyLeftLabel.textColor = .red
         detailView.sizeButton.alpha = 0
         detailView.addToCartButton.isEnabled = false //PB ep69 16mins
         detailView.addToCartButton.setTitleColor(.darkGray, for: .normal)
         detailView.addToCartButton.backgroundColor = .white
         detailView.addToCartButton.layer.borderColor = UIColor.darkGray.cgColor
         detailView.addToCartButton.setTitle("sold out", for: .normal)
         detailView.addToCartButton.alpha = 0.8 //PB ep69 16mins
      }
      
      detailView.descriptionLabel.text = product.summary
      
      if let images = product.productImages { //PB ep69 16mins work on the image //we will check wether product has images or not //productImages which is coming from one to many relationship, we can see that data type is NSSet //so we want to comfort this to an array that will allow us to loop through all the images available
         let allImages = images.allObjects as! [ProductImage] //PB ep69 17mins confort this NSSet to an array images is array of any. Now we need to convert this array of any to an array of ProductImage array
         if let mainImage = allImages.first { //PB ep69 18mins get the first image as the mainImage
            detailView.productImageView.image = Utility.image(withName: mainImage.name, andType: "png") //PB ep69 19mins pass in our image
            
         }
         
         let imageCount = allImages.count //PB ep70 0mins count all the images we have in that product, so we know how many array of buttons to create
         var arrayButtons = [UIButton]() //PB ep70 1mins array of buttons
         detailView.buttonContainerView = UIView() //PB ep70 2mins initialize the buttonContainerView
         
         for x in 0..<imageCount { //PB ep70 2mins loop base on the number of images we have
            let image = Utility.image(withName: allImages[x].name, andType: "png") //PB ep70 3mins image we will have to our buttons
            let buttonImage = image?.resizeImage(newHeight: 40.0) //PB ep70 4mins to have the image resize properly we need an extension //PB ep70 8mins finished
            
            let button = UIButton() //PB ep70 8mins initialize button
            button.setTitle(allImages[x].name, for: .normal) //PB ep70 8mins
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
            } else { //PB ep70 13mins
               button.frame = CGRect(x: arrayButtons[x-1].frame.maxX + 10, y: arrayButtons[x-1].frame.minY, width: 50.0, height: 50.0) //PB ep70 13-16mins to get the x we the arrayButtons[x-1] because we need to get the previous buttons's coordinates, then .frame.maxX to get the furthest X of the previous's button and lastly + 10spaces in between. For y = arrayButtons[x-1].frame.minY, it is the same thing but this time, we get the minimum possible y of the previous button, which allows this method to be reusable even if we go to a new line of buttons
            }
            arrayButtons.append(button) //PB ep70 16mins add it to array
            
            //PB ep70 16mins now we want to show a larger image once button is tapped, we'll create a method for it
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside) //PB ep70 18mins
            detailView.buttonContainerView?.addSubview(button) //PB ep70 18mins we still need to determine the size of containerView
         }
         
         let containerWidth = imageCount * 50 + (imageCount - 1) * 10 //PB ep70 19mins
         detailView.buttonContainerView?.frame = CGRect(x: 20, y: Int(detailView.productImageView.frame.maxY), width: containerWidth, height: 50) //PB ep70 20mins will have 20 spaces on the left, and right underneath productImageView
         detailView.addSubview(detailView.buttonContainerView!) //PB ep70 21mins add it to our DetailSummaryView, remember to reset this view when we switched products
      }
   }
   
   @objc func buttonAction (_ sender: UIButton) { //PB ep70 16mins sender is the uibutton itself
      guard let detailView = detailView else { return }
      if let imageName = sender.currentTitle { //PB ep70 16mins now we need to get the imageName from the button being tapped to display the larger image
         let image = Utility.image(withName: imageName, andType: "png") //PB ep70 16mins get the image from imageName
         detailView.productImageView.image = image //PB ep70 17mins update our productImageView
         detailView.productImageView.contentMode = .scaleAspectFit //PB ep70 17mins
      }
      
   }
   
   func scrollViewDidScroll(_ scrollView: UIScrollView) { //disable horizontal scrolling
      if scrollView.contentOffset.x != 0 {
         scrollView.contentOffset.x = 0
      }
   }
   
   private func setUpViews() {
      timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(animateTopLogo), userInfo: nil, repeats: true)
      
      cartButton.backgroundColor = .clear
      cartButton.layer.cornerRadius = 5
      cartButton.layer.borderWidth = 1.5
      cartButton.layer.borderColor = UIColor.lightGray.cgColor
      
      checkOutButton.backgroundColor = .clear
      checkOutButton.layer.cornerRadius = 5
      checkOutButton.layer.borderWidth = 1.5
      checkOutButton.layer.borderColor = UIColor.yellow.cgColor
   }
   
//   
   private func loadClothesCollection() {
      guard let detailView = detailView else { return }
      detailView.colorsCollection = ProductService.productsCategory(category: productName)
      
      clothesCollection = ProductService.productsCategory(category: productType)
   }
   
   
   //MARK: Status Bar like Time, battery carrier etc.
   override var prefersStatusBarHidden: Bool {
      return false
   }
   override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
   }
   
   
//   override func viewDidLayoutSubviews() {
//      tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height) //set the tableView's x, y, width as normal, and height according to the contents's height
//      tableView.reloadData()
//   }
   
   @objc func animateTopLogo() {
      topLogoImageView.image = UIImage(named: "supremeLogo\(counter)")
      counter += 1
      if counter == 4 {
         counter = 0
      }
   }
   
   
   
   @objc func handleLogoDismiss(_ gesture: UITapGestureRecognizer) {
      self.dismiss(animated: false, completion: nil)
   }
    
   
   @IBAction func backButtonTapped(_ sender: Any) {
      self.dismiss(animated: false, completion: nil)
   }
   
   @IBAction func nextProductButtonTapped(_ sender: Any) {
      self.productIndex += 1
      if self.productIndex == clothesCollection.count {
         self.productIndex = 0
      }
      
      var newProduct: Product = clothesCollection[productIndex]
      
      
      updateView(with: newProduct)
   }
   
   @IBAction func keepShoppingButtonTapped(_ sender: Any) {
      let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
      present(vc, animated: false, completion: nil)
   }
   
   
   
   
//MARK: Private
//   private func showDetail(for currentProduct: Product) { //PB ep68 12mins before we load the product into the detailSummaryView, we check if the view is ready to recieve a product or not (view needs to be loaded first)
//      if viewIfLoaded != nil { //PB ep68 13mins
//         print("showing detail....")
//         detailSummaryView.updateView(with: currentProduct) //PB ep68 14mins pass our currentProduct //now we can call this method in our computed product
//      }
   
      
//   }
}


extension ProductDetailsViewController: UICollectionViewDataSource { //PB ep11 12mins remember we have 2 different collectionView, we need to differentiate which collectionView we're working on. //our methods required for DataSource
   
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //PB ep11 12mins
      switch collectionView { //PB ep11 13mins switch between our collectionView
         
      //tops
      case self.detailView.colorsCollectionView: //PB ep11 13mins
         return self.detailView.colorsCollection.count //PB ep11 13mins
         
      //pants
      case self.detailView.productsCollectionView:
         return self.detailView.productsCollection.count //PB ep11 13mins
         
      default: //PB ep11 13mins
         return 0 //PB ep11 13mins dont display anything
      }
   }
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //PB ep11 12mins
      
      switch collectionView { //PB ep11  //PB ep11 14mins we also need to know which collectionView we're working on in this VC
      //tops
      case self.detailView.colorsCollectionView: //PB ep11 14mins because we the custom collection view cell, we need to subclass the collectionViewCell
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCells", for: indexPath) as! ProductColorsCollectionViewCell //PB ep11 20mins create the cell with the identifier as! our cell.swift
         let product = detailView.colorsCollection[indexPath.row] //PB ep11 21mins get the particular product we want to display in our cell
         cell.productImageView.image = Utility.image(withName: product.mainImage, andType: "png") //PB ep11 22mins this collectionViewCell will only display 1 image from the mainImage from the Product entity
         cell.colorLabel.text = "Color"
         return cell //PB ep11 23mins
         
      //pants
//      case self.productsCollectionView: //PB ep11 14mins
//         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPants", for: indexPath) as! ProductCollectionViewCell //PB ep11
//         let product = productsCollection[indexPath.row] //PB ep11 23mins
//         cell.productImageView.image = Utility.image(withName: product.mainImage, andType: "png") //PB ep11 23mins
//         return cell
         
      default: //PB ep11 14mins
         return UICollectionViewCell() //PB ep11 23mins if nothing then return an instance of cell
      }
      
   }
   //PB ep11 12mins
   
   
}

