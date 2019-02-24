//
//  LoginViewController.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 1/20/19.
//  Copyright © 2019 Samuel Folledo. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
   
   @IBOutlet weak var firstNameTextField: UITextField!
   @IBOutlet weak var lastNameTextField: UITextField!
   @IBOutlet weak var emailTextField: UITextField!
   @IBOutlet weak var passwordTextField: UITextField!
   @IBOutlet weak var confirmPasswordTextField: UITextField!
   
   @IBOutlet weak var topButton: UIButton!
   @IBOutlet weak var bottomButton: UIButton!
   
   
//MARK: Properties
   var isLoginMode: Bool = true
   
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setupViews()
   }
   
   override func viewWillAppear(_ animated: Bool) {
      
      
      updateValuesOfAllViews()
      checkLoginMode()
      
   }
   
   private func updateValuesOfAllViews() {
      isLoginMode = false
   }
   
   private func setupViews() {
      
      firstNameTextField.delegate = self
      lastNameTextField.delegate = self
      emailTextField.delegate = self
      passwordTextField.delegate = self
      confirmPasswordTextField.delegate = self
      
      //init toolbar
      let toolbar:UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0,  width: self.view.frame.size.width, height: 30))
      //create left side empty space so that done button set on right side
      let flexSpace = UIBarButtonItem(barButtonSystemItem:    .flexibleSpace, target: nil, action: nil)
      let doneBtn: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.endEditing))
      toolbar.setItems([flexSpace, doneBtn], animated: false)
      toolbar.sizeToFit()
      //setting toolbar as inputAccessoryView
      self.firstNameTextField.inputAccessoryView = toolbar
      self.lastNameTextField.inputAccessoryView = toolbar
      self.emailTextField.inputAccessoryView = toolbar
      self.passwordTextField.inputAccessoryView = toolbar
      self.confirmPasswordTextField.inputAccessoryView = toolbar
      
      let tap = UITapGestureRecognizer(target: self, action: #selector(self.endEditing))
      self.view.isUserInteractionEnabled = true
      self.view.addGestureRecognizer(tap)
      
      
      topButton.layer.cornerRadius = 5
      topButton.layer.borderWidth = 1.5
      topButton.layer.borderColor = UIColor.black.cgColor
      
      bottomButton.layer.cornerRadius = 5
      
      
      
      updateValuesOfAllViews()
      checkLoginMode()
   }
   
   private func checkLoginMode() {
      if isLoginMode {
         firstNameTextField.isHidden = false
         lastNameTextField.isHidden = false
         confirmPasswordTextField.isHidden = false
         topButton.setTitle("Register", for: .normal)
         bottomButton.setTitle("Switch to Login?", for: .normal)
         isLoginMode = false
      } else {
         firstNameTextField.isHidden = true
         lastNameTextField.isHidden = true
         confirmPasswordTextField.isHidden = true
         topButton.setTitle("Login", for: .normal)
         bottomButton.setTitle("Switch to Register?", for: .normal)
         isLoginMode = true
      }
   }
   
   @objc func endEditing() {
      self.view.endEditing(true)
   }
   
   
//MARK: IBActions
   @IBAction func topButtonTapped(_ sender: Any) {
   }
   
   @IBAction func bottomButtonTapped(_ sender: Any) {
      checkLoginMode()
   }
   
}
