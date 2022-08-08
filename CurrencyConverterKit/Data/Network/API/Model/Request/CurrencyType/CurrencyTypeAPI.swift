//
//  CurrencyType.swift
//  CurrencyConverterKit
//
//  Created by Mehmet Baykar on 8/8/22.
//

import Foundation

public enum SupportedCurrencyTypeAPIModel:String,Codable,CaseIterable{
    case dollar = "USD"
    case euro   = "EUR"
    case yen    = "JPY"
    
    public var code:String{
        switch self {
        case .dollar:
            return "USD"
        case .euro:
            return "EUR"
        case .yen:
            return "JPY"
        }
    }
}
