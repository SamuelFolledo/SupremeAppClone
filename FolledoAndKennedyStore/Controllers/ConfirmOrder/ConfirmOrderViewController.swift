//
//  ConfirmOrderViewController.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 2/24/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit

class ConfirmOrderViewController: UIViewController {
	
//MARK: IBOulets
	@IBOutlet weak var mainView: UIView!
	@IBOutlet weak var topLogoImageView: UIImageView!
	@IBOutlet weak var editCartButton: UIButton!
	
	@IBOutlet weak var orderTableView: UITableView!
	
	
	
//MARK: Properties
	var timer = Timer()
	var counter: Int = 0
	
	var shoppingCart = ShoppingCart.sharedInstance //PB ep95 13mins
	weak var delegate: ShoppingCartDelegate? //PB ep95 28mins
	
	var customer: Customer? //PB ep84 19mins
	var creditCard: CreditCard?
	var addresses = [Address]() //PB ep87 3mins array of Address
	var selectedAddress: Address?
	
	
//MARK: LifeCycle
	override func viewDidLoad() {
		super.viewDidLoad()
		
		orderTableView.register(UINib(nibName: "ItemInCartTableViewCell", bundle: nil), forCellReuseIdentifier: "itemInCartCell") //PB ep78 20mins we need to initiate the XIB file, so we can use it in our TVC //PB ep78 21mins register it with the same name as the file and nil bundle. with the id
		
		setUpViews()
		
		
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		updateCartTableViewFrame()
	}
	
	
	private func setUpViews() {
		timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(animateTopLogo), userInfo: nil, repeats: true)
		
		let tap = UITapGestureRecognizer(target: self, action: #selector(handleLogoDismiss))
		self.topLogoImageView.isUserInteractionEnabled = true
		self.topLogoImageView.addGestureRecognizer(tap)
		
		editCartButton.backgroundColor = .clear
		editCartButton.layer.cornerRadius = 5
		editCartButton.layer.borderWidth = 1.5
		editCartButton.layer.borderColor = UIColor.lightGray.cgColor
		
		updateCartTableViewFrame()
	}
	
	private func updateCartTableViewFrame() {
		orderTableView.frame = CGRect(x: orderTableView.frame.origin.x, y: orderTableView.frame.origin.y, width: orderTableView.frame.size.width, height: orderTableView.contentSize.height + 50) //this will make the tableView's height adapt to its cells
		orderTableView.reloadData()
		
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
	@IBAction func backButtonTapped(_ sender: Any) {
		self.dismiss(animated: false, completion: nil)
	
	}
}



extension ConfirmOrderViewController: UITableViewDelegate, UITableViewDataSource {
	
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 6
	}
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		switch section {
		case 0,2,3,4,5:
			return 1
		case 1:
			return shoppingCart.items.count
		default:
			return 0
		}
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { //PB ep95 17mins
		switch indexPath.section { //PB ep95 17mins
		case 0, 5: //PB ep95 18mins
			tableView.rowHeight = 60 //PB ep95 18mins
			
			let cell = tableView.dequeueReusableCell(withIdentifier: "placeOrderCell", for: indexPath) //PB ep95 18mins
			return cell //PB ep95 19mins
			
		case 1: //PB ep95 19mins
			tableView.rowHeight = 80 //PB ep95 19mins
			
			let item = shoppingCart.items[indexPath.row] //PB ep95 19mins item we want to display, which is already in shoppingCart's items. get each by using indexPath.row
			let cell = tableView.dequeueReusableCell(withIdentifier: "itemInCartCell", for: indexPath) as! ItemInCartTableViewCell //PB ep95 20mins to reuse it, cast it as ItemInCartTVC
			cell.item = item //PB ep95 21mins
			cell.itemIndexPath = indexPath //PB ep95 21mins pass in the current indexPath that is focused
			cell.delegate = self //PB ep95 21mins
			
			return cell //PB ep95 22mins
			
		case 2: //PB ep95 22mins
			tableView.rowHeight = 60 //PB ep95 22mins
			
			let itemStr = shoppingCart.items.count == 1 ? "item" : "items" //PB ep95 23mins
			let cell = tableView.dequeueReusableCell(withIdentifier: "orderTotalCell", for: indexPath) //PB ep95 23mins
			cell.textLabel?.text = "Subtotal \(shoppingCart.totalItem()) \(itemStr))" //PB ep95 24mins
			cell.detailTextLabel?.text = shoppingCart.totalItemCost().currencyFormatter //PB ep95 24mins
			return cell
			
		case 3: //PB ep95 25mins
			tableView.rowHeight = 150 //PB ep95 25mins
			let cell = tableView.dequeueReusableCell(withIdentifier: "shippingCell", for: indexPath) as! ShippingTableViewCell //PB ep95 25mins
			cell.configureCell() //PB ep95 26mins make cell configure itself
			return cell
			
		case 4: //PB ep95 26mins
			tableView.rowHeight = 70 //PB ep95 26mins
			
			let cell = tableView.dequeueReusableCell(withIdentifier: "paymentCell", for: indexPath) as! PaymentInfoTableViewCell //PB ep95 26mins
			cell.configureCell() //PB ep95 26mins configure itself
			return cell //PB ep95 26mins
			
		default: //PB ep95 17mins
			return UITableViewCell() //PB ep95 26mins
		}
		
	}
}
extension ConfirmOrderViewController: ShoppingCartDelegate {  //PB ep95 27mins copy pasted from CartTableVC's ShoppingCartDelegate extension
	func updateTotalCartItem() { //PB ep81 7mins
		delegate?.updateTotalCartItem() //PB ep95 27mins
		orderTableView.reloadData() //PB ep81 10mins we may completely remove a product thats in the cart so we reload tbView
	}
	
	func confirmRemoval(forProduct product: Product, itemIndexPath: IndexPath) { //PB ep95 27mins
		let alertController = UIAlertController(title: "Remove Item", message: "Remove \(String(describing: product.name?.uppercased())) from your shoppig cart?", preferredStyle: .actionSheet) //PB ep95
		
		let removeAction = UIAlertAction(title: "Remove", style: .destructive) { [weak self] (action: UIAlertAction) in //PB ep95 27mins this remove action is going to be only executed if the user agree to remove the item.
			self?.shoppingCart.delete(product: product) //PB ep95 27mins call our shoppingCart's delete method
			self?.orderTableView.deleteRows(at: [itemIndexPath], with: UITableView.RowAnimation.fade) //PB ep95 27mins delete it from our table
			self?.orderTableView.reloadData() //PB ep95
			
			self?.updateTotalCartItem() //PB ep95 27mins update items in the cart itself
		}
		
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil) //PB ep95 27mins
		
		alertController.addAction(removeAction)
		alertController.addAction(cancelAction)
		present(alertController, animated: true, completion: nil) //PB ep95 27mins
	}
}

