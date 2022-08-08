//
//  UIVIew+Extension.swift
//  CurrencyConverter
//
//  Created by Mehmet Baykar on 8/8/22.
//
import UIKit


extension UIView {
    
    func setGradientBackground(leftColor:UIColor,rightColor:UIColor) {
        let gradient = CAGradientLayer()
        gradient.colors = [leftColor.cgColor, rightColor.cgColor]
        gradient.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1)
        gradient.frame = bounds
        gradient.cornerRadius = self.layer.cornerRadius
        layer.insertSublayer(gradient, at: 0)
    }
    
    func roundCorners() {
        clipsToBounds = true
        layer.cornerRadius = frame.size.height / 2
    }
}
