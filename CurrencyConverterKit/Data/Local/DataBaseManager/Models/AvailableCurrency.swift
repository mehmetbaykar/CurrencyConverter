//
//  AvailableCurrency.swift
//  CurrencyConverterKit
//
//  Created by Mehmet Baykar on 8/8/22.
//

import Foundation
import RealmSwift



public class AvailableCurrency: Object {
    @objc public dynamic var currencyName = ""
    @objc public dynamic var currencyAmount = 0.00
    
    public override static func primaryKey() -> String? {
        return "currencyName"
    }
    
    public convenience required init(currencyName: String, amount: Double) {
        self.init()
        self.currencyName = currencyName
        self.currencyAmount = amount
    }
}

