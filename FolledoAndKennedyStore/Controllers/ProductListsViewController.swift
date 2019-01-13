//
//  ProductListsViewController.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 11/20/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import Foundation
import UIKit

class ProductListsViewController: UIViewController, UIScrollViewDelegate {
   
   
   
   @IBOutlet weak var scrollView: UIScrollView!
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var topLogoImageView: UIImageView!
   @IBOutlet weak var cartButton: UIButton!
   @IBOutlet weak var checkOutButton: UIButton!
   
   
   var timer = Timer()
   var counter: Int = 0
   
   var clothesList = [Product]()
   var selectedProduct: Product?
   
   var productType: String = ""
   var productIndex: Int = 0
   
   weak var productDetailsController: ProductDetailsViewController?
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setUpViews()
      loadClothesCollection()
      
      let tap = UITapGestureRecognizer(target: self, action: #selector(handleLogoDismiss))
      self.topLogoImageView.isUserInteractionEnabled = true
      self.topLogoImageView.addGestureRecognizer(tap)
  
      scrollView.delegate = self
      
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
//      let tabBarController = window?.rootViewController as! UITabBarController //PB ep68 16mins this will make reference to the TabBar we have in storyboard
//
//      let splitVC = tabBarController.viewControllers?[1] as! UISplitViewController //PB ep68 17mins viewContrllers is using the index just like an array. First index0 is home, and second1 is browse
//      let masterNavigation = splitVC.viewControllers[0] as! UINavigationController //PB ep68 18mins after we get splitview, we can get the refernce for the masterNavigation master's index is 0, and detail's index is 1
//      let productsTableVC = masterNavigation.topViewController as! ProductsTableViewController //PB ep68 19mins now we can get to tableViewController that represents our master view
//
//      let detailNavigation = splitVC.viewControllers[1] as! UINavigationController //PB ep68 19mins
//      let productDetailVC = detailNavigation.topViewController as! ProductDetailsViewController //PB ep68 20mins
      
//      productsTableVC.delegate = productDetailVC
      
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//      let selectedProduct: Product = clothesList[indexPath.row]
      self.productIndex = indexPath.row
      selectedProduct = clothesList[self.productIndex]
//      productDetailsController?.product = selectedProduct
      
      performSegue(withIdentifier: "toThirdControllerSegue", sender: self.selectedProduct)
   }
   
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "toThirdControllerSegue" {
         let vc = segue.destination as! ProductDetailsViewController
         vc.productIndex = self.productIndex
//         vc.productType = self.productType
         vc.product = sender as? Product
         
//         let selectedProductIndex: IndexPath = IndexPath(row: self.productIndex, section: 0)
//         vc.selectedProductIndexPath = selectedProductIndex
      }
   }
   
   func scrollViewDidScroll(_ scrollView: UIScrollView) { //disable horizontal scrolling
      if scrollView.contentOffset.x != 0 {
         scrollView.contentOffset.x = 0
      }
   }
   
   private func setUpViews() {
//      timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(animateTopLogo), userInfo: nil, repeats: true)
      
      cartButton.backgroundColor = .clear
      cartButton.layer.cornerRadius = 5
      cartButton.layer.borderWidth = 1.5
      cartButton.layer.borderColor = UIColor.lightGray.cgColor
      
      checkOutButton.backgroundColor = .clear
      checkOutButton.layer.cornerRadius = 5
      checkOutButton.layer.borderWidth = 1.5
      checkOutButton.layer.borderColor = UIColor.yellow.cgColor
   }
   
   
   private func loadClothesCollection() {
      clothesList = ProductService.productsCategory(category: productType)
   }
   
   
//MARK: Status Bar like Time, battery carrier etc.
   override var prefersStatusBarHidden: Bool {
      return false
   }
   override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
   }
   
   override func viewDidLayoutSubviews() {
      tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: tableView.contentSize.height) //set the tableView's x, y, width as normal, and height according to the contents's height
      tableView.reloadData()
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
   
}







extension ProductListsViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return clothesList.count
   }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //PB ep11 12mins
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "productNameCell", for: indexPath) as! ProductTableViewCell //PB ep11 20mins create the cell with the identifier as! our cell.swift
      let product = clothesList[indexPath.row] //PB ep11 21mins get the particular product we want to display in our cell
      cell.productImageView.image = Utility.image(withName: product.mainImage, andType: "png") //PB ep11 22mins this collectionViewCell will only display 1 image from the mainImage from the Product entity
      cell.nameLabel.text = product.name
//      print("\(product.name)")
      return cell //PB ep11 23mins
   }
}

extension ProductListsViewController: UITableViewDelegate {
   func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      return 70
   }
}
