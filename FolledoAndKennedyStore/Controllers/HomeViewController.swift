//
//  HomeViewController.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 11/20/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
   
   
   @IBOutlet weak var scrollView: UIScrollView!
   @IBOutlet weak var tableView: UITableView!
   @IBOutlet weak var topLogoImageView: UIImageView!
   @IBOutlet weak var cartButton: UIButton!
   @IBOutlet weak var checkOutButton: UIButton!
   
   
   
//MARK: Properties
   var timer = Timer()
   var counter: Int = 0
   
   var storeCategories: [String] = ["new", "jackets", "shirts", "top", "sweatshirts", "pants", "hats", "bags", "accessories", "skate"]
   
   var clothesCategories = [Product]()
   var selectedProduct: Product?
   var shoppingCart = ShoppingCart.sharedInstance //PB ep76 12mins this guarantee that the shoppingCart property will have the singleton of the ShoppingCart class
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setUpViews()
      
      loadCategories()
      
      scrollView.delegate = self
      
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      self.cartButton.setTitle("\(String(describing: self.shoppingCart.totalItem()))", for: .normal)
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
   
   private func loadCategories() {
//      clothesCategories = ProductService.productsCategory(<#T##String#>)
      
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
  
   
//MARK: TableView DataSource methods
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return storeCategories.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = makeCell(for: tableView) //p.275
      
//      let checklist = storeCategories[indexPath.row] //p.282
      cell.textLabel!.text = storeCategories[indexPath.row] //p.282
      cell.accessoryType = .none //p.282
      
      //cell.detailTextLabel!.text = "\(checklist.countUncheckedItems()) Remaining" //p.328 detailTextLabel Returns the secondary label of the table cell if one exists. ! is necessary because textLabel and detailTextLabel are optionals
      //cell.detailTextLabel!.text is updated in p.331
//      let count = checklist.countUncheckedItems() //p.331
//      if checklist.items.count == 0 { cell.detailTextLabel!.text = "(No Items)" }
//      else if count == 0 { cell.detailTextLabel!.text = "All Done!" } //p.331
//      else { cell.detailTextLabel!.text = "\(count) Remaining" } //p.331
//
//      cell.imageView!.image = UIImage(named: checklist.iconName) //p.338 this will
//
      return cell
   }
   
//makeCell method p.275
   func makeCell(for tableView: UITableView) -> UITableViewCell {
      let cellIdentifier = "productCategoryCell"
      if let cell = tableView.dequeueReusableCell (withIdentifier: cellIdentifier) { //the call dequeueReusableCell(withIdentifier) is still there, except that previously the storyboard had a prototype cell with that identifier and now it doesnt. If the table view cannot find a cell to re-use (it wont until it has enough cells to fill the entire visible area), this method will return nil, and you have to create your own by hand,thus what happens in the else section. p.283
         return cell
      } else {
         return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier) //p.327 chanced the UITableViewCell's style from .default to .subtitle
      }
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      //UserDefaults.standard.set(indexPath.row, forKey: "ChecklistIndex") //p.316 In addition to what this method do before, you now store the index of the selected row into UserDefaults under the key "ChecklistIndex" //replaced in p.322
//      dataModel.indexOfSelectedChecklist = indexPath.row //p.322
//
//      let checklist = dataModel.lists[indexPath.row] //p.284 this will be used to send along the Checklist object from the row that the user tapped on
      let category = storeCategories[indexPath.row]
      print(category)
      performSegue(withIdentifier: "toSecondControllerSegue", sender: category) //p.277 sender: nil until p.284
   }
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "toSecondControllerSegue" {
         let vc = segue.destination as! ProductListsViewController
         vc.productType = sender as! String
      }
   }
}
