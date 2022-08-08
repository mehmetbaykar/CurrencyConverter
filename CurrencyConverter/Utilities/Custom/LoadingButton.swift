//
//  LoadingButton.swift
//  CurrencyConverter
//
//  Created by Mehmet Baykar on 8/8/22.
//

import UIKit

class LoadingButton: UIButton {
    
    var isLoading:Bool = false{
        didSet{
            loadIndicator(isLoading)
        }
    }
    private var activityIndicator: UIActivityIndicatorView!
    private let activityIndicatorColor: UIColor
    
    init(activityIndicatorColor:UIColor = .gray){
        self.activityIndicatorColor = activityIndicatorColor
        
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func loadIndicator(_ shouldShow: Bool) {
        if shouldShow {
            if (activityIndicator == nil) {
                activityIndicator = createActivityIndicator()
            }
            self.isEnabled = false
            self.alpha = 0.7
            showSpinning()
        } else {
            activityIndicator.stopAnimating()
            self.isEnabled = true
            self.alpha = 1.0
        }
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = activityIndicatorColor
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        positionActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }
    
    private func positionActivityIndicatorInButton() {
        let trailingConstraint = NSLayoutConstraint(item: self,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: activityIndicator,
                                                    attribute: .trailing,
                                                    multiplier: 1, constant: 16)
        self.addConstraint(trailingConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .centerY,
                                                   multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
    
}
