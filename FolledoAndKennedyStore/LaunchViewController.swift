//
//  LaunchViewController.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 1/19/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
   
   @IBOutlet weak var logoView: UIView!
   
   @IBOutlet weak var logoImageView: UIImageView!
   @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
   
   @IBOutlet weak var loadingLabel: UILabel!
   
   
   
   override func viewDidLoad() {
      super.viewDidLoad()

      self.activityIndicator.startAnimating()
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      self.activityIndicator.stopAnimating()
   }
   
   
   
}
