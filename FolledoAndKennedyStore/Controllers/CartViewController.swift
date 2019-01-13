//
//  CartViewController.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 12/31/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class CartViewController: UIViewController {
   
   
   
   @IBOutlet weak var cartTableView: UITableView!
   
   @IBOutlet weak var tableStackView: UIStackView!
   
   @IBOutlet weak var topLogoImageView: UIImageView!
   @IBOutlet weak var cartButton: UIButton!
   @IBOutlet weak var checkOutButton: UIButton!
   @IBOutlet weak var keepShoppingButton: UIButton!
   @IBOutlet weak var checkoutButtonBottom: UIButton!
   
   @IBOutlet weak var bottomButtonsStackView: UIStackView!
   
   @IBOutlet weak var bottomButtonsStackView_TopConstraint: NSLayoutConstraint!
   
   //MARK: Properties
   var timer = Timer()
   var counter: Int = 0
   var shoppingCart = ShoppingCart.sharedInstance //PB ep78 9mins get the singleton sharedInstance
   weak var cartDelegate: ShoppingCartDelegate? //PB ep81 8mins
   
   
   
//MARK: Controller LifeCycle
   override func viewDidLoad() {
      super.viewDidLoad()
      
      cartTableView.register(UINib(nibName: "ItemInCartTableViewCell", bundle: nil), forCellReuseIdentifier: "itemInCartCell") //PB ep78 20mins we need to initiate the XIB file, so we can use it in our TVC //PB ep78 21mins register it with the same name as the file and nil bundle. with the id
      
      setUpViews()
      
      
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
//      checkOutButton.isEnabled = shoppingCart.totalItem() > 0 ? true : false
      if shoppingCart.totalItem() > 0 {
         checkOutButton.layer.borderColor = UIColor.yellow.cgColor
         checkOutButton.isEnabled = true
         
         checkoutButtonBottom.backgroundColor = .red
         checkoutButtonBottom.alpha = 1
         checkoutButtonBottom.isEnabled = true
      } else {
         checkOutButton.layer.borderColor = UIColor.darkGray.cgColor
         checkOutButton.isEnabled = false
         
         checkoutButtonBottom.backgroundColor = .lightGray
         checkoutButtonBottom.alpha = 0.75
         checkoutButtonBottom.isEnabled = false
      }
      
      updateCartTableViewFrame()
   }
   
   
   
   
   private func updateCartTableViewFrame() {
      cartTableView.frame = CGRect(x: cartTableView.frame.origin.x, y: cartTableView.frame.origin.y, width: cartTableView.frame.size.width, height: cartTableView.contentSize.height + 50) //this will make the tableView's height adapt to its cells
      cartTableView.reloadData()
//      cartTableView.sizeToFit()
//      cartTableView.layoutIfNeeded()
//      tableStackView.sizeToFit()
//      tableStackView.layoutIfNeeded()
   }
   
   
   
   
   private func setUpViews() {
      let tap = UITapGestureRecognizer(target: self, action: #selector(handleLogoDismiss))
      self.topLogoImageView.isUserInteractionEnabled = true
      self.topLogoImageView.addGestureRecognizer(tap)
      
//      timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(animateTopLogo), userInfo: nil, repeats: true)
      
      cartButton.backgroundColor = .clear
      cartButton.layer.cornerRadius = 5
      cartButton.layer.borderWidth = 1.5
      cartButton.layer.borderColor = UIColor.lightGray.cgColor
      
      checkOutButton.backgroundColor = .clear
      checkOutButton.layer.cornerRadius = 5
      checkOutButton.layer.borderWidth = 1.5
      checkOutButton.layer.borderColor = UIColor.yellow.cgColor
      
      checkoutButtonBottom.backgroundColor = .red
      checkoutButtonBottom.layer.cornerRadius = 5
      
      keepShoppingButton.backgroundColor = .black
      keepShoppingButton.layer.cornerRadius = 5
      
      updateCartTableViewFrame()
      
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
   @IBAction func keepShoppingButtonTapped(_ sender: Any) {
      let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
      present(vc, animated: false, completion: nil)
   }
   
   @IBAction func checkoutButtonTapped(_ sender: Any) {
      let viewController: UIViewController = UIStoryboard(name: "CheckoutSB", bundle: nil).instantiateViewController(withIdentifier: "checkoutVC")
      self.present(viewController, animated: false, completion: nil)
   }
   
   @IBAction func backButtonTapped(_ sender: Any) {
      self.dismiss(animated: false, completion: nil)
   }
   
   
}


//extension CartViewController: UITableViewDelegate {
//   
//}

extension CartViewController: UITableViewDataSource {
   func numberOfSections(in tableView: UITableView) -> Int {
      return 2
   }
   
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      switch section {
      case 0:
         return shoppingCart.items.count
      case 1:
         return 1
      default:
         return 0
      }
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let section = indexPath.section
      switch section { //PB ep78 22mins
   //case 0
      case 0: //PB ep78 22mins
         tableView.rowHeight = 70 //PB ep78 22mins assign the height same as what we have in the xib
         let cell = tableView.dequeueReusableCell(withIdentifier: "itemInCartCell", for: indexPath) as! ItemInCartTableViewCell //PB ep78 23-24mins after we get the item, initiate our cell
         let item = shoppingCart.items[indexPath.row] //PB ep78 23mins, this will be item that will be displayed in each individual cell
         cell.item = item //PB ep78 24mins pass the cell's item to be our item
         cell.itemIndexPath = indexPath
         
         cell.delegate = self //PB ep81 6mins now we implement that method
         return cell
   //case 1
      case 1: //PB ep78 26mins section index 1
         tableView.rowHeight = 40 //PB ep78 26mins
         //Subtotal (xx items) .... $$$
         let itemStr = shoppingCart.items.count == 1 ? "item" : "items" //PB ep78 27mins //PB ep78 26mins get quantity associated with the product in the cell
         let cell = tableView.dequeueReusableCell(withIdentifier: "summaryCell", for: indexPath) //PB ep78 28mins cellSummary is cell's identif in storyboard. Since we a using the basic right detail, we do not need to subclass the cell
         cell.textLabel?.text = "\(shoppingCart.totalItem()) \(itemStr) in you cart" //PB ep78 29mins
         cell.detailTextLabel?.text = "subtotal: \(shoppingCart.totalItemCost().currencyFormatter)" //PB ep78 29mins detailTextLabel is the text on the right side of the cell, this will have the total cost with our currencyFormatter method
         return cell //PB ep78 29mins
         
      default: //PB ep78 22mins
         return UITableViewCell() //PB ep78 29mins
      }
   }
   
   
}


extension CartViewController: ShoppingCartDelegate { //PB ep81 6-8mins
   func updateTotalCartItem() { //PB ep81 7mins
      cartDelegate?.updateTotalCartItem() //PB ep81 9mins
      
//      checkOutButton.isEnabled = shoppingCart.totalItem() > 0 ? true : false //PB ep81 10mins
      if shoppingCart.totalItem() > 0 {
         checkOutButton.layer.borderColor = UIColor.yellow.cgColor
         checkOutButton.isEnabled = true
         
         checkoutButtonBottom.backgroundColor = .red
         checkoutButtonBottom.alpha = 1
         checkoutButtonBottom.isEnabled = true
      } else {
         checkOutButton.layer.borderColor = UIColor.darkGray.cgColor
         checkOutButton.isEnabled = false
         
         checkoutButtonBottom.backgroundColor = .lightGray
         checkoutButtonBottom.alpha = 0.75
         checkoutButtonBottom.isEnabled = false
         
      }
      cartTableView.reloadData() //PB ep81 10mins we may completely remove a product thats in the cart so we reload tbView
   }
   
   
   func confirmRemoval(forProduct product: Product, itemIndexPath: IndexPath) { //PB ep81 10mins whenever user wants to remove something, we will have to make them confirm so they dont remove something by accident
      let alertController = UIAlertController(title: "Remove Item", message: "Remove \(String(describing: product.name!.uppercased())) from your shopping cart?", preferredStyle: .actionSheet) //PB ep81 11mins
      
      let removeAction = UIAlertAction(title: "Remove", style: .destructive) { [weak self] (action: UIAlertAction) in //PB ep81 12-13mins this remove action is going to be only executed if the user agree to remove the item.
         self?.shoppingCart.delete(product: product) //PB ep81 13mins call our shoppingCart's delete method
         self?.cartTableView.deleteRows(at: [itemIndexPath], with: UITableView.RowAnimation.fade) //PB ep81 14mins delete it from our table
         self?.cartTableView.reloadData() //PB ep81 15mins refresh
         
         self?.updateTotalCartItem() //PB ep81 15mins update items in the cart itself
      }
      
      let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil) //PB ep81 16mins do nothing
      
      alertController.addAction(removeAction) //PB ep81 16mins
      alertController.addAction(cancelAction) //PB ep81 16mins
      present(alertController, animated: true, completion: nil) //PB ep81 16mins dont forget to implement the delegate in the productDetailViewController, to handle updateTotalCartItem
   }
   
}
