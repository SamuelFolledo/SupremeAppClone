//
//  UserRating.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 11/27/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit

class UserRating: UIView { //PB ep65 2mins //PB ep65 6mins so now the rating itself, the value will be coming from the Product Rating. In order to accept that rating frm the Product, when this UserRating is invoke from our TableViewCell, we need be able to set the rating that we want it to be represented by the star //PB ep65 16mins make this as the class of that view in main storyboard and connect this view to the TableViewCell
   
   
   var rating = 0 { //PB ep65 7mins a computed property //when this property is being set from the TableViewCell, we want to trigger the updated layout for the rating
      didSet { //PB ep65 7mins
         setNeedsLayout() //PB ep65 7mins call this method which invalidates the current layout of the receiver and triggers a layout update during the next update cycle
      }
   }
   
   var ratingButtons = [UIButton]() //PB ep65 5mins property for button array
   
   
   required init?(coder aDecoder: NSCoder) { //PB ep65 2mins required in UIView.
      super.init(coder: aDecoder) //PB ep65 2mins because we are subclassing the UIView we need to call this
      
      let filledStarImage = UIImage(named: "yellowstar") //PB ep65 3mins prepare image for each of the star
      let emptyStarImage = UIImage(named: "blackstar") //PB ep65 3mins and empty star
      
      for _ in 0..<5 { //PB ep65 3mins since we know that the most star we can get is 5 star, we can create a loop for it loop 0 until less than 5
         let button = UIButton() //PB ep65 4mins
         button.setImage(emptyStarImage, for: .normal) //PB ep65 4mins set the button image base on the state of the button
         button.setImage(filledStarImage, for: .selected) //PB ep65 4mins for selected
         button.adjustsImageWhenHighlighted = false //PB ep65 5mins adjustsImageWhenHighlighted = A Boolean value that determines whether the image changes when the button is highlighted. when it is highlighted i dont want to make any changes
         
         ratingButtons += [button] //PB ep65 6mins add the buttons to the button array //this is like adding an array to another array
         addSubview(button) //PB ep65 6mins add the button to the view itself
      }
   }
   
   
   override func layoutSubviews() { //PB ep65 7mins this will be called whenever we set the rating
      //PB ep65 8mins in this layoutsubviews, we are going to initialize the button size and the frame
      //PB ep65 8mins set the button's width and height
      let buttonSize = Int(frame.size.height) //PB ep65 8mins size is from the frame of the view //equal to the view's height //we initialize this to have a height of 12
      var buttonFrame = CGRect(x: 0, y: 0, width: buttonSize, height: buttonSize) //PB ep65 9-10mins determines the position of the star 0 0 0 0 0 //x of first star = 0, then the next x of the next star if the star's width is 5 will be 10 to allow some space in between them
      
      var x = 0 //PB ep65 10mins
      
      for button in ratingButtons { //PB ep65 11mins now we can loop through ratingButtons which we set initially
         buttonFrame.origin.x = CGFloat(x * (buttonSize + 5)) //PB ep65 12mins so if buttonSize is 12, the next star's x will be 17
         button.frame = buttonFrame //PB ep65 13mins set the button's frame to be our buttonFrame
         x += 1 //PB ep65 13mins increment the x
      }
      updateButtonSelectionState() //PB ep65 13mins after we are done setting up the frame for the button then we want to update each of those frame with either a filled star or empty star
   }
   
   private func updateButtonSelectionState() { //PB ep65 13mins
      var x = 0 //PB ep65 14mins we are going to set the state of the button itself
      
      for button in ratingButtons { //PB ep65 14mins each of this button, we're going to set the selection based on the rating value that being set on the top
         button.isSelected = x < rating //PB ep65 14mins so because rating is 1 and x is 0 this will evaluate to a true, the first button will have the selected equals true. And because it is true, it will use the filled star image
         //if rating is 2 then x will be true (will be selected and have the filled star image) //once it is 3 the rest of the star will be empty stars
         x += 1 //PB ep65 15mins
      }
      
   }
   
   
}
