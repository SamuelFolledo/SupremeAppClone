//
//  CheckoutViewController.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 12/31/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController, UITextFieldDelegate {
   
   
//MARK: IBOutlets
   @IBOutlet weak var topLogoImageView: UIImageView!
   @IBOutlet weak var cartButton: UIButton!
   @IBOutlet weak var editCartButton: UIButton!
   
   @IBOutlet weak var mainScrollView: UIScrollView!
   
   @IBOutlet weak var nameTextField: UITextField!
   @IBOutlet weak var emailTextField: UITextField!
   @IBOutlet weak var telephoneTextField: UITextField!
   @IBOutlet weak var addressTextField: UITextField!
   @IBOutlet weak var aptUnitTextField: UITextField!
   @IBOutlet weak var zipTextField: UITextField!
   @IBOutlet weak var cityTextField: UITextField!
   @IBOutlet weak var stateTextField: UITextField!
   @IBOutlet weak var countryTextField: UITextField!
   @IBOutlet weak var rememberAddressButton: UIButton!
   
   @IBOutlet weak var cardNumberTextField: UITextField!
   @IBOutlet weak var cardMonthTextField: UITextField!
   @IBOutlet weak var cardYearTextField: UITextField!
   @IBOutlet weak var cardCvvTextField: UITextField!
   
   @IBOutlet weak var subtotalLabel: UILabel!
   @IBOutlet weak var shipLabel: UILabel!
   @IBOutlet weak var orderTotalLabel: UILabel!
   @IBOutlet weak var agreeButton: UIButton!
   
   
   @IBOutlet weak var captchaImageView: UIImageView!
   @IBOutlet weak var spinningCaptchaImageView: UIImageView!
   
   @IBOutlet weak var captchaActivityIndicator: UIActivityIndicatorView!
   @IBOutlet weak var cancelButton: UIButton!
   @IBOutlet weak var processPaymentButton: UIButton!
   
   //error labels
   @IBOutlet weak var nameErrorLabel: UILabel!
   @IBOutlet weak var emailErrorLabel: UILabel!
   @IBOutlet weak var telephoneErrorLabel: UILabel!
   @IBOutlet weak var addressErrorLabel: UILabel!
   @IBOutlet weak var aptUnitErrorLabel: UILabel!
   @IBOutlet weak var zipErrorLabel: UILabel!
   @IBOutlet weak var cityErrorLabel: UILabel!
   @IBOutlet weak var stateErrorLabel: UILabel!
   @IBOutlet weak var countryErrorLabel: UILabel!
   @IBOutlet weak var cardNumberErrorLabel: UILabel!
   @IBOutlet weak var cardMonthErrorLabel: UILabel!
   @IBOutlet weak var cardYearErrorLabel: UILabel!
   @IBOutlet weak var cardCvvErrorLabel: UILabel!
   @IBOutlet weak var agreeErrorLabel: UILabel!
   @IBOutlet weak var captchaErrorLabel: UILabel!
   
   
//MARK: Properties
   var timer = Timer()
   var counter: Int = 0
   var shoppingCart = ShoppingCart.sharedInstance //PB ep78 9mins get the singleton sharedInstance
   
   var rememberAddressButtonValue: Bool = false
   var agreeButtonValue: Bool = false
   var captchaValue: Bool = false
   
   var statePicker = UIPickerView()
   var countryPicker = UIPickerView()
   var monthPicker = UIPickerView()
   var yearPicker = UIPickerView()
   var yearArray: [Int] = []
   
   
//MARK: Life Cycle
   override func viewDidLoad() {
      super.viewDidLoad()
      
      setUpViews()
      
      
      
      
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      updateValuesOfAllViews()
   }
   
   override func viewWillDisappear(_ animated: Bool) {
      super.viewWillDisappear(animated)
      self.timer.invalidate()
      
      rememberAddressButtonValue = false
      captchaValue = false
      agreeButtonValue = false
      captchaActivityIndicator.isHidden = true
      captchaActivityIndicator.stopAnimating()
   }
   
   private func updateValuesOfAllViews() {
      let addressButtonImage: String = rememberAddressButtonValue ? "check-box" : "blank-check-box"
      rememberAddressButton.setImage(UIImage(named: addressButtonImage), for: .normal)
      
      let agreeButtonImage: String = agreeButtonValue ? "check-box" : "blank-check-box"
      agreeButton.setImage(UIImage(named: agreeButtonImage), for: .normal)
      
      let imageName: String = self.captchaValue ? "captcha2" : "captcha"
      self.captchaImageView.image = UIImage(named: imageName)
      
      subtotalLabel.text = "\(shoppingCart.totalItemCost().currencyFormatter)"
      shipLabel.text = "$10.00"
      orderTotalLabel.text = "\((shoppingCart.totalItemCost() + 10).currencyFormatter)"
      captchaActivityIndicator.isHidden = true
   }
   
   
//MARK: Methods
   private func setUpViews() {
//      timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(animateTopLogo), userInfo: nil, repeats: true)
      let tap = UITapGestureRecognizer(target: self, action: #selector(handleLogoDismiss))
      self.topLogoImageView.isUserInteractionEnabled = true
      self.topLogoImageView.addGestureRecognizer(tap)
      
      cartButton.backgroundColor = .clear
      cartButton.layer.cornerRadius = 5
      cartButton.layer.borderWidth = 1.5
      cartButton.layer.borderColor = UIColor.lightGray.cgColor
      
      editCartButton.backgroundColor = .clear
      editCartButton.layer.cornerRadius = 5
      editCartButton.layer.borderWidth = 1.5
      editCartButton.layer.borderColor = UIColor.lightGray.cgColor
      
      cancelButton.layer.cornerRadius = 5
      processPaymentButton.layer.cornerRadius = 5
      
      updateValuesOfAllViews()
      
      let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(handleEndEditing(_:)))
      self.mainScrollView.addGestureRecognizer(scrollViewTap)
      
      
      let captchaTap = UITapGestureRecognizer(target: self, action: #selector(captchaTap(_:)))
      self.captchaImageView.addGestureRecognizer(captchaTap)
      
      setupTextFields()
      setupPickers()
      
   }
   
   private func setupPickers() {
      statePicker.delegate = self
      countryPicker.delegate = self
      monthPicker.delegate = self
      yearPicker.delegate = self
      
      setupYearArray()
      
      let toolBar = UIToolbar() //RE ep.57 2mins Tool bar on top of the picker where we'll put our Done button
      toolBar.sizeToFit() //RE ep. //RE ep.57 2mins
      let flexibleBar = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) //RE ep.57 2mins this will push the Done Button all the way to the right
      let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.handleEndEditing(_:))) //RE ep.57 3mins
      toolBar.setItems([flexibleBar, doneButton], animated: true) //RE ep.57 4mins add the two bar buttons to our toolBar
      
      stateTextField.inputAccessoryView = toolBar
      stateTextField.inputView = statePicker
      
      countryTextField.inputAccessoryView = toolBar
      countryTextField.inputView = countryPicker
      
      cardMonthTextField.inputAccessoryView = toolBar
      cardMonthTextField.inputView = monthPicker
      
      cardYearTextField.inputAccessoryView = toolBar
      cardYearTextField.inputView = yearPicker
      
   }
   
   private func setupTextFields() {
      nameTextField.delegate = self
      emailTextField.delegate = self
      telephoneTextField.delegate = self
      addressTextField.delegate = self
      aptUnitTextField.delegate = self
      zipTextField.delegate = self
      cityTextField.delegate = self
      stateTextField.delegate = self
      countryTextField.delegate = self
      
      cardNumberTextField.delegate = self
      cardMonthTextField.delegate = self
      cardYearTextField.delegate = self
      cardCvvTextField.delegate = self
      
   }
   
   func setupYearArray() { //RE ep.59 3mins
      for i in 2019...2050 { //RE ep.59 3mins
         yearArray.append(i) //RE ep.59 4mins add 1800 to 2030
      }
//      yearArray.reverse() //RE ep.59 5mins start from 2030 and not in 1800
   }
   
   private func rotateCaptcha(degrees: Double) {
      UIView.animate(withDuration: 2, animations: {
         self.spinningCaptchaImageView.transform = CGAffineTransform(rotationAngle: self.radians(degrees: degrees)) //make a 360 rotation
      })
   }
   private func radians(degrees: Double) -> CGFloat {
      return CGFloat(degrees * .pi / 180)
   }
   
//MARK: Status Bar like Time, battery carrier etc.
   override var prefersStatusBarHidden: Bool {
      return false
   }
   override var preferredStatusBarStyle: UIStatusBarStyle {
      return .lightContent
   }
   
   
//MARK: Helpers
   @objc func captchaTap(_ gesture: UITapGestureRecognizer) {
      if !captchaValue { //if imageView has been transformed
         self.rotateCaptcha(degrees: 180)
         self.rotateCaptcha(degrees: 360)
         self.captchaValue = true
         
      } else { //if captchaValue = true
         self.rotateCaptcha(degrees: 180)
         self.rotateCaptcha(degrees: 360)
         self.captchaValue = false
      }
      
      self.view.isUserInteractionEnabled = false //disable everything
      self.captchaActivityIndicator.startAnimating()
      self.captchaActivityIndicator.isHidden = false
      
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1.8) {
         self.view.isUserInteractionEnabled = true
         self.captchaActivityIndicator.stopAnimating()
         self.captchaActivityIndicator.isHidden = true
         print("captchaValue = \(self.captchaValue)")
         let imageName: String = self.captchaValue ? "captcha2" : "captcha"
         self.captchaImageView.image = UIImage(named: imageName)
      }
   }
   
   @objc func handleEndEditing(_ gesture: UITapGestureRecognizer) {
      self.view.endEditing(true)
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
   @IBAction func processPaymentButtonTapped(_ sender: UIButton) {

      if !agreeButtonValue { //if theyre false
         agreeErrorLabel.text = "terms must be accepted"
         return
      } else { agreeErrorLabel.text = "" }
      
      if !captchaValue {
         captchaErrorLabel.text = "chapta not confirmed"
         return
      } else { captchaErrorLabel.text = "" }
      
      
      
      let alertVC = UIAlertController(title: "Thank you for your purchase", message: "Hope to see you again", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
         alertVC.dismiss(animated: true, completion: nil)
      }
      alertVC.addAction(okAction)
      self.present(alertVC, animated: true, completion: nil)
      
   }
   
   @IBAction func cancelButtonTapped(_ sender: UIButton) {
      let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
      present(vc, animated: false, completion: nil)
   }
   
   
   @IBAction func agreeButtonTapped(_ sender: UIButton) {
      if agreeButtonValue == false {
         agreeButtonValue = true
         agreeButton.setImage(UIImage(named: "check-box"), for: .normal)
      } else {
         agreeButtonValue = false
         agreeButton.setImage(UIImage(named: "blank-check-box"), for: .normal)
      }
   }
   
   @IBAction func rememberAddressButtonTapped(_ sender: UIButton) {
      if rememberAddressButtonValue == false {
         rememberAddressButtonValue = true
         rememberAddressButton.setImage(UIImage(named: "check-box"), for: .normal)
      } else {
         rememberAddressButtonValue = false
         rememberAddressButton.setImage(UIImage(named: "blank-check-box"), for: .normal)
      }
   }
   
   @IBAction func editCartButtonTapped(_ sender: UIButton) {
      let viewController: UIViewController = UIStoryboard(name: "CartSB", bundle: nil).instantiateViewController(withIdentifier: "cartVC")
      self.present(viewController, animated: false, completion: nil)
   }
   @IBAction func backButtonTapped(_ sender: Any) {
      self.dismiss(animated: false, completion: nil)
   }
   
   
} //~~~~~~~~~~~~~~~~~ END OF CLASS ~~~~~~~~~~~~~~~~~~~


//MARK: PickerView DataSource and Delegate
extension CheckoutViewController: UIPickerViewDataSource, UIPickerViewDelegate {
   func numberOfComponents(in pickerView: UIPickerView) -> Int {
      return 1
   }
   
   func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
      
      if pickerView == countryPicker { return countryPickerValues.count }
      
      if pickerView == statePicker {
         
         if countryTextField.text == "U.S." {
            return stateUSPickerValues.count
         } else if countryTextField.text == "Canada" {
            return stateCandaPickerValues.count
         }
      }
      if pickerView == monthPicker { return monthPickerValues.count }
      
      if pickerView == yearPicker { return yearArray.count }
      
      return 0 //RE ep.56 5mins
   }
   
   func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
      if pickerView == countryPicker { return countryPickerValues[row] }
      
      if pickerView == statePicker {
         
         if countryTextField.text == "U.S." {
            return stateUSPickerValues[row]
         } else if countryTextField.text == "Canada" {
            return stateCandaPickerValues[row]
         }
      }
      if pickerView == monthPicker { return monthPickerValues[row] }
      
      if pickerView == yearPicker { return "\(yearArray[row])" }
      
      return ""
   }
   
   
   func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//      var rowValue = row
      
      if pickerView == countryPicker {
         if countryTextField.text != countryPickerValues[row] {
            countryTextField.text = countryPickerValues[row]
            stateTextField.text = ""
         }
         countryTextField.text = countryPickerValues[row]
      }
      
      if pickerView == statePicker {
         
         if countryTextField.text == "U.S." {
            stateTextField.text = String(stateUSPickerValues[row].suffix(2))
         } else if countryTextField.text == "Canada" {
            stateTextField.text = String(stateCandaPickerValues[row].suffix(2))
         }
      }
      if pickerView == monthPicker { cardMonthTextField.text = monthPickerValues[row] }
      
      if pickerView == yearPicker { cardYearTextField.text = "\(yearArray[row])" }
      
   }
   
}

