//
//  UIImage+extension.swift
//  FolledoAndKennedyStore
//
//  Created by Samuel Folledo on 12/3/18.
//  Copyright © 2018 Samuel Folledo. All rights reserved.
//

import UIKit //PB ep70 4mins

extension UIImage { //PB ep70 5mins
   func resizeImage(newHeight: CGFloat) -> UIImage {
      let scale = newHeight / self.size.height //PB ep70 5mins the self here is the uiimage that we passed in when we call this method
      let newWidth = self.size.width * scale //PB ep70 6mins
      
      UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight)) //PB ep70 7mins UIGraphicsBeginImageContext = Creates a bitmap-based graphics context and makes it the current context.
      self.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight)) //PB ep70 7mins
      let newImage = UIGraphicsGetImageFromCurrentImageContext() //PB ep70 7mins get the scaled image
      
      UIGraphicsEndImageContext() //PB ep70 7mins end uiGraphics
      return newImage! //PB ep70 8mins
   }
   
   
}
