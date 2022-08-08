//
//  Double+Extension.swift
//  CurrencyConverter
//
//  Created by Mehmet Baykar on 8/8/22.
//

import Foundation

extension Double {
    func round(to digits: Int = 2) -> Double {
        let divisor = pow(10.0, Double(digits))
        return (self * divisor).rounded() / divisor
    }
}
