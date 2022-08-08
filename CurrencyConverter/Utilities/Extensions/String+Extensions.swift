//
//  String+Extensions.swift
//  CurrencyConverter
//
//  Created by Mehmet Baykar on 8/8/22.
//

import Foundation

extension String {
    
    var doubleValue: Double {
        return (self as NSString).doubleValue
    }
    
    var isNumeric : Bool {
        return NumberFormatter().number(from: self) != nil
    }
}
