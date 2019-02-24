//
//  Service.swift
//  FolledoMyCourt
//
//  Created by Samuel Folledo on 7/14/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit
//import Firebase
//import FirebaseDatabase
//import FirebaseAuth

class Service { //FB ep.29 1mins
   
   static let buttonTitleFontSize: CGFloat = 16
   static let buttonTitleColor = UIColor.white
   //static let buttonBackgroundColorSignInAnonymously = UIColor(red: 88, green: 86, blue: 214, alpha: 1)
   static let facebookColor = UIColor(rgb: 0x4267B2) //facebook's blue
   static let buttonCornerRadius: CGFloat = 5
   
   
   //presentAlert
   static func presentAlert(on: UIViewController, title: String, message: String) {
      let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
      let okAction = UIAlertAction(title: "Ok", style: .default) { (action) in
         alertVC.dismiss(animated: true, completion: nil)
      }
      alertVC.addAction(okAction)
      on.present(alertVC, animated: true, completion: nil)
   }
   
   static func hideButton(button: UIButton) {
      UIView.animate(withDuration: 0.3) {
         button.backgroundColor = .clear
         button.alpha = 0.5
      }
   }
   
   static func showButton(button: UIButton) {
      UIView.animate(withDuration: 0.3) {
         button.backgroundColor = self.facebookColor
         button.alpha = 1
      }
   }
   
   
   static func isValidWithEmail(email: String) -> Bool { //FB ep.29 2mins validate email
      /*
       1) declare a rule
       2) apply this rule in NSPredicate
       3) evaluate the test with the email we received
       */
      let regex:CVarArg = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}" //FB ep.29 5mins // [A-Z0-9a-z._%+-] means capital A-Z, and small letters a-z, and number 0 - 9, and . _ % + and - are allowed (which is samuelfolledo in samuelfolledo@gmail.com). PLUS @ and the next format [A-Za-z0-9.-] which allows all small letters, big letters, and integers, and . - (which is the @[gmail] in samuelfolledo@gmail.com). COMPULSARY AND which will allow small and big letters only like .com or .uk. {2,} and the minimum symboys are at least 2 symbols
      let test = NSPredicate(format: "SELF MATCHES %@", regex) //FB ep.29 6mins we want it to be matching with out regex rules
      let result = test.evaluate(with: email) //FB ep.29 7mins
      
      return result //FB ep.29 7mins
   }
   
   
   static func isValidWithName(name: String) -> Bool { //FB ep.29 8mins
      let regex = "[A-Za-z]{2,}" //FB ep.29 9mins allow letters only with at least 2 chars for the name
      let test = NSPredicate(format: "SELF MATCHES %@", regex) //FB ep.29 10mins
      let result = test.evaluate(with: name) //FB ep.29 10mins
      
      return result  //FB ep.29 11mins
   }
   
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) { //gave padding a default value of zero
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: padding.bottom).isActive = true
        }
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: padding.right).isActive = true
        }
    }
    
    
//    func checkCurrentUser() {
//        let storageRef = Storage.storage().reference()
//        let databaseRef = Database.database().reference()
//        if Auth.auth().currentUser == nil{
////            dispatch_async(dispatch_get_main_queue(), {() -> Void in
//            DispatchQueue.main.async {
//                let loginController = LoginController()
//                self.present(loginController, animated: true, completion: nil)
//            }
//            
//        } else {
//            //observe userLogin
////            Analytics.logEventWithName(kFIREventLogin, parameters: nil)
//            let userID = FIRAuth.auth()?.currentUser?.uid
//            
//            self.databaseRef.child("users").child(userID!).observeEventType(.Value, withBlock: { (snapshot) in
//                // Get user value
//                dispatch_async(dispatch_get_main_queue()){
//                    let username = snapshot.value!["username"] as! String
//                    self.userNameLabel.text = username
//                    // check if user has photo
//                    if snapshot.hasChild("userPhoto"){
//                        // set image locatin
//                        let filePath = "\(userID!)/\("userPhoto")"
//                        // Assuming a < 10MB file, though you can change that
//                        self.storageRef.child(filePath).dataWithMaxSize(10*1024*1024, completion: { (data, error) in
//                            let userPhoto = UIImage(data: data!)
//                            self.userPhoto.image = userPhoto
//                        })
//                    }
//                    
//                }
//                
//            })
//        }
//    }
    
}

/*
 (void) setup {
 
 //View 1
 UIView *view1 = [[UIView alloc] init];
 view1.backgroundColor = [UIColor blueColor];
 [view1.heightAnchor constraintEqualToConstant:100].active = true;
 [view1.widthAnchor constraintEqualToConstant:120].active = true;
 
 
 //View 2
 UIView *view2 = [[UIView alloc] init];
 view2.backgroundColor = [UIColor greenColor];
 [view2.heightAnchor constraintEqualToConstant:100].active = true;
 [view2.widthAnchor constraintEqualToConstant:70].active = true;
 
 //View 3
 UIView *view3 = [[UIView alloc] init];
 view3.backgroundColor = [UIColor magentaColor];
 [view3.heightAnchor constraintEqualToConstant:100].active = true;
 [view3.widthAnchor constraintEqualToConstant:180].active = true;
 
 //Stack View
 UIStackView *stackView = [[UIStackView alloc] init];
 
 stackView.axis = UILayoutConstraintAxisVertical;
 stackView.distribution = UIStackViewDistributionEqualSpacing;
 stackView.alignment = UIStackViewAlignmentCenter;
 stackView.spacing = 30;
 
 
 [stackView addArrangedSubview:view1];
 [stackView addArrangedSubview:view2];
 [stackView addArrangedSubview:view3];
 
 stackView.translatesAutoresizingMaskIntoConstraints = false;
 [self.view addSubview:stackView];
 
 
 //Layout for Stack View
 [stackView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = true;
 [stackView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor].active = true;
 }
 */
