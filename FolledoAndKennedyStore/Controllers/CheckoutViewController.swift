//
//  CheckoutViewController.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 12/31/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {
   
   @IBOutlet weak var topLogoImageView: UIImageView!
   @IBOutlet weak var cartButton: UIButton!
   @IBOutlet weak var checkOutButton: UIButton!
   
//MARK: Properties
   var timer = Timer()
   var counter: Int = 0
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setUpViews()
      
      let tap = UITapGestureRecognizer(target: self, action: #selector(handleLogoDismiss))
      self.topLogoImageView.isUserInteractionEnabled = true
      self.topLogoImageView.addGestureRecognizer(tap)
      
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
