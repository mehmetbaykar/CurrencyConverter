//
//  CurrencyRequestModel.swift
//  CurrencyConverterKit
//
//  Created by Mehmet Baykar on 8/8/22.
//

import Foundation

public struct CurrencyRequestAPIModel:Codable{
    let fromAmount:String
    let fromCurrency:SupportedCurrencyTypeAPIModel
    let toCurrency:SupportedCurrencyTypeAPIModel
}
