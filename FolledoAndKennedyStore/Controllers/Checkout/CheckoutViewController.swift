//
//  CheckoutViewController.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 12/31/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class CheckoutViewController: UIViewController {
	
//MARK: IBOutlets
	@IBOutlet weak var topLogoImageView: UIImageView!
	@IBOutlet weak var cartButton: UIButton!
	@IBOutlet weak var editCartButton: UIButton!
	
	@IBOutlet weak var mainScrollView: UIScrollView!
	
	@IBOutlet weak var firstNameTextField: UITextField!
	@IBOutlet weak var lastNameTextField: UITextField!
	
	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var telephoneTextField: UITextField!
	@IBOutlet weak var addressTextField: UITextField!
	@IBOutlet weak var aptUnitTextField: UITextField!
	@IBOutlet weak var zipTextField: UITextField!
	@IBOutlet weak var cityTextField: UITextField!
	@IBOutlet weak var stateTextField: UITextField!
	@IBOutlet weak var countryTextField: UITextField!
	@IBOutlet weak var rememberAddressButton: UIButton!
	
	@IBOutlet weak var rememberAddressLabel: UILabel!
	
	@IBOutlet weak var cardNumberTextField: UITextField!
	@IBOutlet weak var cardMonthTextField: UITextField!
	@IBOutlet weak var cardYearTextField: UITextField!
	@IBOutlet weak var cardCvvTextField: UITextField!
	
	@IBOutlet weak var subtotalLabel: UILabel!
	@IBOutlet weak var shipLabel: UILabel!
	@IBOutlet weak var orderTotalLabel: UILabel!
	@IBOutlet weak var agreeButton: UIButton!
	
	@IBOutlet weak var agreeLabel: UILabel!
	
	@IBOutlet weak var captchaImageView: UIImageView!
	@IBOutlet weak var spinningCaptchaImageView: UIImageView!
	
	@IBOutlet weak var captchaActivityIndicator: UIActivityIndicatorView!
	@IBOutlet weak var cancelButton: UIButton!
	@IBOutlet weak var processPaymentButton: UIButton!
	
	//error labels
	@IBOutlet weak var firstNameErrorLabel: UILabel!
	@IBOutlet weak var lastNameErrorLabel: UILabel!
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
	var customer: Customer?
	
	var rememberAddressButtonValue: Bool = false
	var agreeButtonValue: Bool = false
	var captchaValue: Bool = false
	
	var statePicker = UIPickerView()
	var countryPicker = UIPickerView()
	var monthPicker = UIPickerView()
	var yearPicker = UIPickerView()
	var yearArray: [Int] = []
	var addressTextFieldsArray: [UITextField] = []
	var cardTextFieldsArray: [UITextField] = []
	
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
		
		if rememberAddressButtonValue {
			saveCustomerAddress()
		} else {
			deleteCustomerAddress()
		}
		
		captchaValue = false
		agreeButtonValue = false
		captchaActivityIndicator.isHidden = true
		captchaActivityIndicator.stopAnimating()
	}
	
//MARK: Navigations
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		switch segue.identifier {
		case "confirmOrderSegue":
			let confirmOrderVC = segue.destination as! ConfirmOrderViewController //PB ep85 31mins once we have the customer, we want to set the destination of the controller
			confirmOrderVC.customer = self.customer //PB ep85 32mins
			
		default:
			break
		}
	}
	
	
//MARK: Methods
	private func updateValuesOfAllViews() {
		if let rememberAddressValue: Bool = UserDefaults.standard.object(forKey: "rememberCustomerAddress") as? Bool { //retrieving UserDefaults
			self.rememberAddressButtonValue = rememberAddressValue
			
			if rememberAddressButtonValue == true {
				let customerAddressValues: [String] = (UserDefaults.standard.array(forKey: "customerAddress") as? [String])!
				
				if customerAddressValues.isEmpty { //check if empty
					print("customerAddress has no value")
					return
				} else { //put the value to the textfield
					
					for value in 0 ..< customerAddressValues.count { //loop through
						addressTextFieldsArray[value].text = customerAddressValues[value] //put the customerAddress saved from UserDefaults
					}
				}
			}
		}
		
		let addressButtonImage: String = rememberAddressButtonValue ? "check-box" : "blank-check-box"
		rememberAddressButton.setImage(UIImage(named: addressButtonImage), for: .normal)
//		rememberAddressButton.setBackgroundImage(UIImage(named: addressButtonImage), for: .normal)
		rememberAddressButton.tintColor = .black
		
		let agreeButtonImage: String = agreeButtonValue ? "check-box" : "blank-check-box"
		agreeButton.setImage(UIImage(named: agreeButtonImage), for: .normal)
//		agreeButton.setBackgroundImage(UIImage(named: agreeButtonImage), for: .normal)
		agreeButton.tintColor = .black
		
		let imageName: String = captchaValue ? "captcha2" : "captcha"
		self.captchaImageView.image = UIImage(named: imageName)
		
		subtotalLabel.text = "\(shoppingCart.totalItemCost().currencyFormatter)"
		shipLabel.text = "$10.00"
		orderTotalLabel.text = "\((shoppingCart.totalItemCost() + 10).currencyFormatter)"
		captchaActivityIndicator.isHidden = true
	}
	
	private func setUpViews() {
		//      timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(animateTopLogo), userInfo: nil, repeats: true)
		let tapImage = UITapGestureRecognizer(target: self, action: #selector(handleLogoDismiss))
		self.topLogoImageView.isUserInteractionEnabled = true
		self.topLogoImageView.addGestureRecognizer(tapImage)
		
		let tapRememberAddress = UITapGestureRecognizer(target: self, action: #selector(CheckoutViewController.rememberAddressTapped))
		self.rememberAddressLabel.isUserInteractionEnabled = true
		self.rememberAddressLabel.addGestureRecognizer(tapRememberAddress)
		
		let tapAgreeTerms = UITapGestureRecognizer(target: self, action: #selector(CheckoutViewController.agreeTermsTapped))
		self.agreeLabel.isUserInteractionEnabled = true
		self.agreeLabel.addGestureRecognizer(tapAgreeTerms)
		
		
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
		
		
		
		let scrollViewTap = UITapGestureRecognizer(target: self, action: #selector(handleEndEditing(_:)))
		self.mainScrollView.addGestureRecognizer(scrollViewTap)
		
		
		let captchaTap = UITapGestureRecognizer(target: self, action: #selector(captchaTap(_:)))
		self.captchaImageView.addGestureRecognizer(captchaTap)
		
		setupTextFields()
		setupPickers()
		updateValuesOfAllViews()
		resetErrorLabels()
	}
	
	private func resetErrorLabels() {
		firstNameErrorLabel.isHidden = true
		firstNameTextField.layer.borderColor = CLEARLAYERCOLOR
		lastNameErrorLabel.isHidden = true
		lastNameTextField.layer.borderColor = CLEARLAYERCOLOR
		
		emailErrorLabel.isHidden = true
		emailTextField.layer.borderColor = CLEARLAYERCOLOR
		telephoneErrorLabel.isHidden = true
		telephoneTextField.layer.borderColor = CLEARLAYERCOLOR
		addressErrorLabel.isHidden = true
		addressTextField.layer.borderColor = CLEARLAYERCOLOR
		aptUnitErrorLabel.isHidden = true
		aptUnitTextField.layer.borderColor = CLEARLAYERCOLOR
		zipErrorLabel.isHidden = true
		zipTextField.layer.borderColor = CLEARLAYERCOLOR
		cityErrorLabel.isHidden = true
		cityTextField.layer.borderColor = CLEARLAYERCOLOR
		stateErrorLabel.isHidden = true
		stateTextField.layer.borderColor = CLEARLAYERCOLOR
		countryErrorLabel.isHidden = true
		countryTextField.layer.borderColor = CLEARLAYERCOLOR
		cardNumberErrorLabel.isHidden = true
		cardNumberTextField.layer.borderColor = CLEARLAYERCOLOR
		cardMonthErrorLabel.isHidden = true
		cardMonthTextField.layer.borderColor = CLEARLAYERCOLOR
		cardYearErrorLabel.isHidden = true
		cardYearTextField.layer.borderColor = CLEARLAYERCOLOR
		cardCvvErrorLabel.isHidden = true
		cardCvvTextField.layer.borderColor = CLEARLAYERCOLOR
		agreeErrorLabel.textColor = .clear
		captchaErrorLabel.isHidden = true
		
	}
	
	private func setupPickers() {
		statePicker.delegate = self
		countryPicker.delegate = self
		monthPicker.delegate = self
		yearPicker.delegate = self
		
		setupYearArray()
		
		let nextToolBar = UIToolbar() //RE ep.57 2mins Tool bar on top of the picker where we'll put our Done button
		nextToolBar.sizeToFit() //RE ep. //RE ep.57 2mins
		let flexibleBar = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil) //RE ep.57 2mins this will push the Done Button all the way to the right
		let nextButton = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(self.handleNextEditing(_:)))
		nextToolBar.setItems([flexibleBar, nextButton], animated: true) //RE ep.57 4mins add the two bar buttons to our toolBar
		
		let doneToolBar = UIToolbar()
		let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.handleEndEditing(_:))) //RE ep.57 3mins
		doneToolBar.setItems([flexibleBar, doneButton], animated: true)
		
		telephoneTextField.inputAccessoryView = nextToolBar
		zipTextField.inputAccessoryView = nextToolBar
		cardNumberTextField.inputAccessoryView = nextToolBar
		cardCvvTextField.inputAccessoryView = doneToolBar //will contain doneToolBar
		
		
		stateTextField.inputAccessoryView = nextToolBar
		stateTextField.inputView = statePicker
		
		countryTextField.inputAccessoryView = nextToolBar
		countryTextField.inputView = countryPicker
		
		cardMonthTextField.inputAccessoryView = nextToolBar
		cardMonthTextField.inputView = monthPicker
		
		cardYearTextField.inputAccessoryView = nextToolBar
		cardYearTextField.inputView = yearPicker
		
	}
	
	private func setupTextFields() {
//		firstNameTextField.delegate = self
//		lastNameTextField.delegate = self
//		emailTextField.delegate = self
//		telephoneTextField.delegate = self
//		addressTextField.delegate = self
//		aptUnitTextField.delegate = self
//		zipTextField.delegate = self
//		cityTextField.delegate = self
//		stateTextField.delegate = self
//		countryTextField.delegate = self
//
//		cardNumberTextField.delegate = self
//		cardMonthTextField.delegate = self
//		cardYearTextField.delegate = self
//		cardCvvTextField.delegate = self
		
		self.addressTextFieldsArray = [firstNameTextField, lastNameTextField, emailTextField, telephoneTextField, addressTextField, aptUnitTextField, zipTextField, cityTextField, stateTextField, countryTextField]
		self.cardTextFieldsArray = [cardNumberTextField, cardMonthTextField, cardYearTextField, cardCvvTextField]
		
		//borderWidth
//		firstNameTextField.layer.borderWidth = 1
//		lastNameTextField.layer.borderWidth = 1
//		emailTextField.layer.borderWidth = 1
//		telephoneTextField.layer.borderWidth = 1
//		addressTextField.layer.borderWidth = 1
//		aptUnitTextField.layer.borderWidth = 1
//		zipTextField.layer.borderWidth = 1
//		cityTextField.layer.borderWidth = 1
//		stateTextField.layer.borderWidth = 1
//		countryTextField.layer.borderWidth = 1
//
//		cardNumberTextField.layer.borderWidth = 1
//		cardMonthTextField.layer.borderWidth = 1
//		cardYearTextField.layer.borderWidth = 1
//		cardCvvTextField.layer.borderWidth = 1
		
		//border Color
		for textField in addressTextFieldsArray + cardTextFieldsArray {
			textField.delegate = self
			textField.layer.borderWidth = 1
			textField.layer.borderColor = CLEARLAYERCOLOR
		}
//		firstNameTextField.layer.borderColor = CLEARLAYERCOLOR
//		lastNameTextField.layer.borderColor = CLEARLAYERCOLOR
//		emailTextField.layer.borderColor = CLEARLAYERCOLOR
//		telephoneTextField.layer.borderColor = CLEARLAYERCOLOR
//		addressTextField.layer.borderColor = CLEARLAYERCOLOR
//		aptUnitTextField.layer.borderColor = CLEARLAYERCOLOR
//		zipTextField.layer.borderColor = CLEARLAYERCOLOR
//		cityTextField.layer.borderColor = CLEARLAYERCOLOR
//		stateTextField.layer.borderColor = CLEARLAYERCOLOR
//		countryTextField.layer.borderColor = CLEARLAYERCOLOR
//
//		cardNumberTextField.layer.borderColor = CLEARLAYERCOLOR
//		cardMonthTextField.layer.borderColor = CLEARLAYERCOLOR
//		cardYearTextField.layer.borderColor = CLEARLAYERCOLOR
//		cardCvvTextField.layer.borderColor = CLEARLAYERCOLOR
	}
	
	func setupYearArray() { //RE ep.59 3mins
		let now = Date()
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy"
		
		let currentYear: Int = Int(dateFormatter.string(from: now))!
		let maxYearInt: Int = currentYear + 12
		
		for i in currentYear...maxYearInt {
			yearArray.append(i)
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
			captchaErrorLabel.isHidden = true
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
	
	@objc func rememberAddressTapped() {
		
		if rememberAddressButtonValue == false {
			saveCustomerAddress()
			
		} else {
			deleteCustomerAddress()
			
			let alert = UIAlertController(title: "Removing Saved Address", message: "Are you sure you want to remove remembered address?", preferredStyle: .alert)
			let yesAction = UIAlertAction(title: "Yes", style: .default) { (action) in
				self.firstNameTextField.text = ""
				self.lastNameTextField.text = ""
				self.emailTextField.text = ""
				self.telephoneTextField.text = ""
				self.addressTextField.text = ""
				self.aptUnitTextField.text = ""
				self.zipTextField.text = ""
				self.cityTextField.text = ""
				self.stateTextField.text = ""
			}
			let noAction = UIAlertAction(title: "No", style: .cancel) { (action) in
				alert.dismiss(animated: true, completion: nil)
			}
			alert.addAction(noAction)
			alert.addAction(yesAction)
			
			present(alert, animated: true, completion: nil)
		}
	}
	private func saveCustomerAddress() { //method that will save the user in UserDefaults
        var aptUnitString: String = ""
        if aptUnitTextField.text != "" || aptUnitTextField.text != " " || !aptUnitTextField.text!.isEmpty {
            aptUnitString = aptUnitTextField.text!
        }
        
		let textFieldValues: [String] = ["\(firstNameTextField.text!.trimmedString())", "\(lastNameTextField.text!.trimmedString())", "\(emailTextField.text!.trimmedString())", "\(telephoneTextField.text!.trimmedString())", "\(addressTextField.text!.trimmedString())", aptUnitString, "\(zipTextField.text!.trimmedString())", "\(cityTextField.text!.trimmedString())", "\(stateTextField.text!.trimmedString())", "\(countryTextField.text!.trimmedString())"]
		
		self.rememberAddressButtonValue = true
		self.rememberAddressButton.setImage(UIImage(named: "check-box"), for: .normal)
		
		UserDefaults.standard.set(textFieldValues, forKey: "customerAddress")
		UserDefaults.standard.set(rememberAddressButtonValue, forKey: "rememberCustomerAddress")
	}
	private func deleteCustomerAddress() { //remove our customerAddress and rememberCustomerAddress
		rememberAddressButtonValue = false
		rememberAddressButton.setImage(UIImage(named: "blank-check-box"), for: .normal)
		
		UserDefaults.standard.removeObject(forKey: "customerAddress")
		UserDefaults.standard.removeObject(forKey: "rememberCustomerAddress")
	}
	
	@objc func handleNextEditing(_ gesture: UITapGestureRecognizer) {
		
		if telephoneTextField.isFirstResponder {
			addressTextField.becomeFirstResponder()
		} else if zipTextField.isFirstResponder {
				cityTextField.becomeFirstResponder()
		} else if stateTextField.isFirstResponder {
			countryTextField.becomeFirstResponder()
		} else if countryTextField.isFirstResponder {
			cardNumberTextField.becomeFirstResponder()
		} else if cardNumberTextField.isFirstResponder {
			cardMonthTextField.becomeFirstResponder()
		} else if cardMonthTextField.isFirstResponder {
			cardYearTextField.becomeFirstResponder()
		} else if cardYearTextField.isFirstResponder {
			cardCvvTextField.becomeFirstResponder()
		} else {
			resignFirstResponder()
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
	@objc func agreeTermsTapped() {
		if agreeButtonValue == false {
			agreeButtonValue = true
			agreeButton.setBackgroundImage(UIImage(named: "check-box"), for: .normal)
			agreeButton.setImage(UIImage(named: "check-box"), for: .normal)
		} else {
			agreeButtonValue = false
			agreeButton.setBackgroundImage(UIImage(named: "blank-check-box"), for: .normal)
			agreeButton.setImage(UIImage(named: "blank-check-box"), for: .normal)
		}
	}
	
	
	private func processPayment() throws {
		
		if !agreeButtonValue { //if theyre false
			throw CheckoutError.uncheckedAgreeButton
		} else { agreeErrorLabel.textColor = .clear }
		
		if !captchaValue {
			throw CheckoutError.uncheckedCaptcha
		} else { captchaErrorLabel.isHidden = true }
		
//check customer's textField
		for tf in addressTextFieldsArray {
			switch tf {
			case firstNameTextField:
				if checkIfTextFieldIsEmpty(textField: firstNameTextField) {
					throw CheckoutError.incompleteForm }
				
				validateTextField(textField: firstNameTextField, withType: "name")
				if firstNameTextField.layer.borderColor == REDLAYERCOLOR {
					print("Invalid first name, throwing error")
					throw CheckoutError.invalidName
				}
				
			case lastNameTextField:
				if checkIfTextFieldIsEmpty(textField: lastNameTextField) {
					throw CheckoutError.incompleteForm }
				
				validateTextField(textField: lastNameTextField, withType: "name")
				if lastNameTextField.layer.borderColor == REDLAYERCOLOR {
					print("Invalid last name, throwing error")
					throw CheckoutError.invalidName
				}
				
			case emailTextField:
				if checkIfTextFieldIsEmpty(textField: emailTextField) {
					throw CheckoutError.incompleteForm }
				
				validateTextField(textField: emailTextField, withType: "email")
				
				
			case telephoneTextField:
				if checkIfTextFieldIsEmpty(textField: telephoneTextField) {
					throw CheckoutError.incompleteForm }
				
				validateTextField(textField: telephoneTextField, withType: "phone")
				
			case addressTextField:
				if checkIfTextFieldIsEmpty(textField: addressTextField) {
					throw CheckoutError.incompleteForm }
				
				validateTextField(textField: addressTextField, withType: "address")
				
			case cityTextField:
				if checkIfTextFieldIsEmpty(textField: cityTextField) {
					throw CheckoutError.incompleteForm }
				
				validateTextField(textField: cityTextField, withType: "address")
				
			case stateTextField:
				if checkIfTextFieldIsEmpty(textField: stateTextField) {
					throw CheckoutError.incompleteForm }
				
				validateTextField(textField: stateTextField, withType: "state")
				
			case zipTextField:
				if checkIfTextFieldIsEmpty(textField: zipTextField) {
					throw CheckoutError.incompleteForm }
				
				validateTextField(textField: zipTextField, withType: "zipNumber")
				
			default:
				break
			}
		}
		
//Credit Card TextFields
		for tf in cardTextFieldsArray {
			switch tf {
			case cardNumberTextField:
				if checkIfTextFieldIsEmpty(textField: cardNumberTextField) {
					throw CheckoutError.incompleteForm }
				
				validateTextField(textField: cardNumberTextField, withType: "cardNumber")
				
			case cardMonthTextField:
				if checkIfTextFieldIsEmpty(textField: cardMonthTextField) {
					throw CheckoutError.incompleteForm }
				
				validateTextField(textField: cardMonthTextField, withType: "cardMonth")
				
			case cardYearTextField:
				if checkIfTextFieldIsEmpty(textField: cardYearTextField) {
					throw CheckoutError.incompleteForm }
				
				validateTextField(textField: cardYearTextField, withType: "cardYear")
				
			case cardCvvTextField:
				if checkIfTextFieldIsEmpty(textField: cardCvvTextField) {
					throw CheckoutError.incompleteForm }
				
				validateTextField(textField: cardCvvTextField, withType: "cardCvv")
				
			default:
				break
			}
		}
		
	//evaluate all textFields
		let allTextFields: [UITextField] = addressTextFieldsArray + cardTextFieldsArray
		var hasError = false
		
		for tf in allTextFields {
			if tf.layer.borderColor == REDLAYERCOLOR {
				hasError = true
			}
		}
		
	//check for errors
		if !hasError {
			guard let firstName = firstNameTextField.text?.trimmedString(),
				let lastName = lastNameTextField.text?.trimmedString(),
				let email = emailTextField.text?.trimmedString(),
				let phoneNumber = telephoneTextField.text?.trimmedString(),
				let address1 = addressTextField.text?.trimmedString(),
				let city = cityTextField.text?.trimmedString(),
				let state = stateTextField.text?.trimmedString(),
				let zip = zipTextField.text?.trimmedString(),
				let cardNumber: String = cardNumberTextField.text?.trimmedString(),
				let expMonth = Int16((cardMonthTextField.text?.trimmedString())!),
				let expYear = Int16((cardYearTextField.text?.trimmedString())!),
				let cvv = Int16((cardCvvTextField.text?.trimmedString())!) else { print("hasError check has missing textFields"); return }
		//addCustomer
			let customer = CustomerService.addCustomer(firstName: firstName, lastName: lastName, email: email, phone: phoneNumber) //addCustomer
			shoppingCart.assignCart(toCustomer: customer) //assign our cart to our customer
			
			var address: Address
			if !(addressTextField.text?.isEmpty)! && !(cityTextField.text?.isEmpty)! && !(stateTextField.text?.isEmpty)! && !(zipTextField.text?.isEmpty)! {
				address = CustomerService.addAddress(forCustomer: customer, address1: address1, city: city, state: state, zip: zip, phone: phoneNumber)
				
				shoppingCart.assignShipping(address: address)
			}
			
		//Add the Credit Card
			let creditCard = CustomerService.addCreditCard(forCustomer: customer, firstName: firstName, lastName: lastName, cardNumber: cardNumber, expMonth: Int(expMonth), expYear: Int(expYear), cvv: Int(cvv)) //PB ep91 27mins
			shoppingCart.creditCard = creditCard
			
			performSegue(withIdentifier: "confirmOrderSegue", sender: nil)
		}
		
		
	}
	
	private func checkIfTextFieldIsEmpty(textField: UITextField) -> Bool { //true if no text
		if textField.text!.isEmpty || textField.text == "" || textField.text == " " {
			textField.layer.borderColor = REDLAYERCOLOR
			return true //if there is no text then return true
		} else {
			textField.layer.borderColor = CLEARLAYERCOLOR
			return false
		}
	}
	
	private func validateTextField(textField: UITextField, withType type: String) {
		
		switch type {
		case "name":
			guard let name = textField.text else { return }
			if !Service.isValidName(name: name) {
				textField.layer.borderColor = REDLAYERCOLOR
			} else {
				textField.layer.borderColor = CLEARLAYERCOLOR
			}
		case "email":
			guard let email = textField.text else { return }
			if !Service.isValidEmail(email: email) { //if not valid
				textField.layer.borderColor = REDLAYERCOLOR
			} else { textField.layer.borderColor = CLEARLAYERCOLOR }
		case "phone":
			print("Name")
		case "address":
			print("Name")
		case "cardNumber":
			print("Name")
		case "cardExp":
			print("Name")
		default:
			break
		}
	}
	
//MARK: IBActions
	@IBAction func processPaymentButtonTapped(_ sender: UIButton) {
		do {
//			resetErrorLabels()
			try processPayment()
			
		} catch CheckoutError.uncheckedAgreeButton {
			agreeErrorLabel.textColor = .red
			agreeErrorLabel.text = "terms must be accepted"
			agreeButton.tintColor = .red
		} catch CheckoutError.uncheckedCaptcha {
			captchaErrorLabel.isHidden = false
			captchaErrorLabel.text = "captcha error"
			
		} catch CheckoutError.invalidFormat {
			Service.presentAlert(on: self, title: "Incomplete Form", message: "Please fill out all fields")
		} catch CheckoutError.incompleteForm {
			Service.presentAlert(on: self, title: "Incomplete Forms", message: "Some fields are missing")
		} catch { //default error
			Service.presentAlert(on: self, title: "Unable To Checkout", message: "There was an error when attempting to processing the payment.\nPlease try again.")
		}
	}
	
	@IBAction func cancelButtonTapped(_ sender: UIButton) {
		let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "homeVC") as! HomeViewController
		present(vc, animated: false, completion: nil)
	}
	
	@IBAction func agreeButtonTapped(_ sender: UIButton) {
		agreeTermsTapped()
//		guard let customFont = UIFont(name: "CustomFont-Light", size: UIFont.labelFontSize) else {
//			fatalError("""
//        Failed to load the "CustomFont-Light" font.
//        Make sure the font file is included in the project and the font name is spelled correctly.
//        """
//			)
//		}
//		label.font = UIFontMetrics.default.scaledFont(for: customFont)
//		label.adjustsFontForContentSizeCategory = true
	}
	
	@IBAction func rememberAddressButtonTapped(_ sender: UIButton) {
		rememberAddressTapped()
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
		if pickerView == monthPicker { cardMonthTextField.text = String(monthPickerValues[row].suffix(2)) }
		
		if pickerView == yearPicker { cardYearTextField.text = "\(yearArray[row])" }
		
	}
	
}

extension CheckoutViewController: UITextFieldDelegate {
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		switch textField {
		case firstNameTextField:
			lastNameTextField.becomeFirstResponder()
		case lastNameTextField:
			emailTextField.becomeFirstResponder()
		case emailTextField:
			telephoneTextField.becomeFirstResponder()
			
		case telephoneTextField:
			addressTextField.becomeFirstResponder()
		case addressTextField:
			aptUnitTextField.becomeFirstResponder()
		case aptUnitTextField:
			zipTextField.becomeFirstResponder()
			
		case zipTextField:
			cityTextField.becomeFirstResponder()
		case cityTextField:
			stateTextField.becomeFirstResponder()
		case stateTextField:
			countryTextField.becomeFirstResponder()
			
		case countryTextField:
			cardNumberTextField.becomeFirstResponder()
		case cardNumberTextField:
			cardMonthTextField.becomeFirstResponder()
		case cardMonthTextField:
			cardYearTextField.becomeFirstResponder()
		case cardYearTextField:
			cardCvvTextField.becomeFirstResponder()
		case cardCvvTextField:
			textField.resignFirstResponder()
		default:
			textField.resignFirstResponder()
		}
		
		return true
	}
}
