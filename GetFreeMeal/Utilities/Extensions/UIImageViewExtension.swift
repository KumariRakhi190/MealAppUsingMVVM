//  UIImageViewExtension.swift
//  FreeMeal
//
//  Created by Rakhi Kumari on 14/09/24.


import Foundation
import UIKit

extension UIImageView {
    
    // Sets the corner radius of the image view.
    func setCornerRadiusOfImage(_ radius: CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
    }
    
    // Sets the border width and color of the image view.
    func setBorderOfImage(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    
    // Combines setting both the border and corner radius for the image view.
    func setBorderAndCornerRadiusOfImage(borderWidth: CGFloat, color: UIColor, cornerRadius: CGFloat) {
        self.layer.borderColor = color.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.cornerRadius = cornerRadius
        self.layer.masksToBounds = true
    }
}

