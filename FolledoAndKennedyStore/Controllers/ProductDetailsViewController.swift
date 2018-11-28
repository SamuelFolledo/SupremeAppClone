//
//  ProductDetailsViewController.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 11/27/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class ProductDetailsViewController: UIViewController, UIScrollViewDelegate {
   
   
   @IBOutlet weak var scrollView: UIScrollView!
   @IBOutlet weak var topLogoImageView: UIImageView!
   @IBOutlet weak var cartButton: UIButton!
   @IBOutlet weak var checkOutButton: UIButton!
   @IBOutlet weak var nextProductButton: UIButton!
   @IBOutlet weak var keepShoppingButton: UIButton!
   
   @IBOutlet weak var detailSummaryView: DetailSummaryView!
   
   
   var timer = Timer()
   var counter: Int = 0
   
   var clothesCollection = [Product]()
   var productName: String = ""
   
   var selectedProduct: Product?
   
   var product: Product? {
      didSet {
         if let currentProduct = product {
            self.showDetail(for: currentProduct)
         }
      }
   }
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setUpViews()
//      loadClothesCollection()
      
      let tap = UITapGestureRecognizer(target: self, action: #selector(handleLogoDismiss))
      self.topLogoImageView.isUserInteractionEnabled = true
      self.topLogoImageView.addGestureRecognizer(tap)
      
      scrollView.delegate = self
      
      print("THE SELECTED PRODUCT IS = \(product)")
      if let currentProduct = product {
         self.showDetail(for: currentProduct)
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
//   private func loadClothesCollection() {
//      clothesCollection = ProductService.productsCategory(type: productType)
//   }
   
   
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
   }
   
   @IBAction func keepShoppingButtonTapped(_ sender: Any) {
   }
   
   
   
   
//MARK: Private
   private func showDetail(for currentProduct: Product) { //PB ep68 12mins before we load the product into the detailSummaryView, we check if the view is ready to recieve a product or not (view needs to be loaded first)
      if viewIfLoaded != nil { //PB ep68 13mins
         print("showing detail....")
         detailSummaryView.updateView(with: currentProduct) //PB ep68 14mins pass our currentProduct //now we can call this method in our computed product
      }
      
      
   }
   
   
}
