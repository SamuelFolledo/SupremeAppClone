//
//  ProductDetailsViewController.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 11/27/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController {
   
   @IBOutlet weak var detailView: DetailSummaryView!
   
   @IBOutlet weak var topLogoImageView: UIImageView!
   @IBOutlet weak var cartButton: UIButton!
   @IBOutlet weak var checkOutButton: UIButton!
   @IBOutlet weak var nextProductButton: UIButton!
   @IBOutlet weak var keepShoppingButton: UIButton!
   
   @IBOutlet weak var colorsCollectionView: UICollectionView!
   @IBOutlet weak var productsCollectionView: UICollectionView!
   
   @IBOutlet weak var mainScrollView: UIScrollView!
   
//MARK: Properties
   var timer = Timer()
   var counter: Int = 0
   
   var clothesCollection = [Product]()
   var colorsCollection = [Product]()
   var productType = ""
   
   var productName: String = ""
   
   var selectedProduct: Product?
   
   var productIndex = 0
   var product: Product? {
      didSet {
         if let currentProduct = product {
            self.updateProductImages(with: currentProduct)
            self.updateProductDetailView(with: currentProduct)
         }
      }
   }
   var productOtherImages = [String]()
   
   var selectedColorIndexPath: IndexPath? {
      didSet {
         self.colorsCollectionView.reloadData()
      }
   }
   var selectedProductIndexPath: IndexPath? {
      didSet {
         self.productsCollectionView.reloadData()
      }
   }
   
   public var detailSummary: DetailSummary?
   
   
	
   
//MARK: CollectionView Properties
   let colorsCellId: String = "productColorCell"
   let productsCellId: String = "productsCell"
   
   
   
//MARK: LifeCycle
   override func viewDidLoad() {
      super.viewDidLoad()
      
      print("THE SELECTED PRODUCT's COLOR IS = \(String(describing: product?.mainColor))")
      
      setUpViews()
      loadClothesCollection()
      
      let tap = UITapGestureRecognizer(target: self, action: #selector(handleLogoDismiss))
      self.topLogoImageView.isUserInteractionEnabled = true
      self.topLogoImageView.addGestureRecognizer(tap)
      
      
      updateProductDetailView(with: self.product!)
//      self.view.layoutIfNeeded() //updates the layout constraints
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      if let product = product {
         productName = product.name!
         productType = product.type!
         loadClothesCollection()
         
         selectedColorIndexPath = IndexPath(row: 0, section: 0)
         selectedProductIndexPath = IndexPath(row: self.productIndex, section: 0) //this makes the selected product from ProductListViewController become the selected product in productCollectionView
         
         colorsCollectionView.reloadData()
         productsCollectionView.reloadData()
         updateProductDetailView(with: product)
      }
   }
   
   
   func updateProductDetailView(with product: Product) { //PB ep68 10mins
      guard let detailView = detailView else { return }
      detailView.updateView(with: product)
   } //end of updateProductDetailView
   
   
   func updateProductImages(with product: Product) {
      productOtherImages.removeAll()
      if let images = product.productImages {
         let allImages = images.allObjects as! [ProductImage]
         let imageCount = allImages.count
         for x in 0 ..< imageCount { //PB ep70 2mins loop base on the number of images we have
            guard let imageName = allImages[x].name else { return }
            productOtherImages.append(imageName)
         }
//         print("\nFound \(productOtherImages.count) images in this product\n")
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
      
      
      colorsCollectionView.delegate = self
      colorsCollectionView.dataSource = self
      productsCollectionView.delegate = self
      productsCollectionView.dataSource = self
   }
   
   
   func loadClothesCollection() {
      guard let product = product else { print("no product"); return }
      colorsCollection = ProductService.productsColors(productName: product.name!)
      
      clothesCollection = ProductService.productsCategory(category: product.type!)
//      print("\n\nimages found for this product is \(productOtherImages.count)\ncolors Collection found is \(colorsCollection.count)\nclothes Collection found is \(clothesCollection.count)\n\n")
   }
   
   
   //MARK: Status Bar like Time, battery carrier etc.
   override var prefersStatusBarHidden: Bool {
      return false
   }
   override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
   }
   
	
   
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
	
//MARK: IBActions
   @IBAction func checkoutButtonTapped(_ sender: Any) {
      let viewController: UIViewController = UIStoryboard(name: "CheckoutSB", bundle: nil).instantiateViewController(withIdentifier: "checkoutVC")
      self.present(viewController, animated: false, completion: nil)
   }
   
   @IBAction func cartButtonTapped(_ sender: Any) {
      let viewController: UIViewController = UIStoryboard(name: "CartSB", bundle: nil).instantiateViewController(withIdentifier: "cartVC")
      self.present(viewController, animated: false, completion: nil)
   }
   
   @IBAction func backButtonTapped(_ sender: Any) {
      self.dismiss(animated: false, completion: nil)
   }
   @IBAction func nextProductButtonTapped(_ sender: Any) {
      self.productIndex += 1
      if self.productIndex == clothesCollection.count {
         self.productIndex = 0
      }
      
      let newProduct: Product = clothesCollection[productIndex]
      
      updateProductDetailView(with: newProduct)
      updateProductImages(with: newProduct)
      self.colorsCollectionView.reloadData()
      self.productsCollectionView.reloadData()
   }
   @IBAction func keepShoppingButtonTapped(_ sender: Any) {
      let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
      present(vc, animated: false, completion: nil)
   }
   
   
//setupCell
   private func setupCell(cell: ProductColorsCollectionViewCell, product: Product) {
      
   }
	
}


extension ProductDetailsViewController: UICollectionViewDataSource {
   func numberOfSections(in collectionView: UICollectionView) -> Int {
      return 1
   }
   
//MARK: CollectionView DataSource
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { //PB ep11 12mins
      switch collectionView {
      case self.colorsCollectionView: //PB ep11 13mins
         return self.productOtherImages.count
         
      case self.productsCollectionView:
         return self.clothesCollection.count //PB ep11 13mins
         
      default: //PB ep11 13mins
         return 0 //PB ep11 13mins dont display anything
      }
   }
   
   
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell { //PB ep11 12mins
//      print("Creating collectionview")
      switch collectionView {
         
      case self.colorsCollectionView:
         let cell = colorsCollectionView.dequeueReusableCell(withReuseIdentifier: colorsCellId, for: indexPath) as! ProductColorsCollectionViewCell
         let productImageName = productOtherImages[indexPath.row]
         
         cell.productImageView.image = Utility.image(withName: productImageName, andType: "png")
         cell.productLabel.text = "\(productImageName)"
//         setupCell(cell: cell, product: self.product!)
         
         var borderColor: CGColor! = UIColor.clear.cgColor
         var borderWidth: CGFloat = 0
         
         if indexPath == selectedColorIndexPath {
            borderColor = UIColor.red.cgColor
            borderWidth = 2 //or whatever you please
         } else {
            borderColor = UIColor.clear.cgColor
            borderWidth = 0
         }
         
         cell.layer.borderWidth = borderWidth
         cell.layer.borderColor = borderColor
         
         
         return cell //PB ep11 23mins

      case self.productsCollectionView: //PB ep11 14mins
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: productsCellId, for: indexPath) as! ProductColorsCollectionViewCell //PB ep11
         let product = clothesCollection[indexPath.row] //PB ep11 23mins
         cell.productImageView.image = Utility.image(withName: product.mainImage, andType: "png") //PB ep11 23mins
         cell.productLabel.text = "\(String(describing: product.name!))"
         
         var borderColor: CGColor! = UIColor.clear.cgColor
         var borderWidth: CGFloat = 0
         
         if indexPath == selectedProductIndexPath {
            borderColor = UIColor.red.cgColor
            borderWidth = 2 //or whatever you please
         } else {
            borderColor = UIColor.clear.cgColor
            borderWidth = 0
         }
         
         cell.layer.borderWidth = borderWidth
         cell.layer.borderColor = borderColor
         
         return cell
      default: //PB ep11 14mins
         return UICollectionViewCell() //PB ep11 23mins if nothing then return an instance of cell
      }
   }
   
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      
      switch collectionView {
      case self.colorsCollectionView: //PB ep11 13mins
         selectedColorIndexPath = indexPath
         let productImageName = productOtherImages[indexPath.row]
         self.detailView.productImageView.image = Utility.image(withName: productImageName, andType: "png")
         
         
      case self.productsCollectionView:
         let newProduct: Product = clothesCollection[indexPath.row]
         updateProductDetailView(with: newProduct) //update text in detailView
         updateProductImages(with: newProduct) //update images of colorsCollectionView
         
         selectedProductIndexPath = indexPath
         selectedColorIndexPath?.row = 0
         
      default: //PB ep11 13mins
         return //PB ep11 13mins dont display anything
      }
      
   }
   
}

extension ProductDetailsViewController: UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		return CGSize()
	}
}

extension ProductDetailsViewController: UIScrollViewDelegate {
   func scrollViewDidScroll(_ scrollView: UIScrollView) { //disable horizontal scrolling
      if scrollView == mainScrollView {
         if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
         }
      }
   }
}
