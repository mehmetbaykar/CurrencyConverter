//
//  ConvertCurrency.swift
//  CurrencyConverterKit
//
//  Created by Mehmet Baykar on 8/8/22.
//

import PromiseKit

public protocol ConvertCurrency{
    func convertCurrency(fromAmount: String,
                         fromCurrency: String,
                         toCurrency: String) -> Promise<CurrencyAPIResponse?>
}

final class ConvertCurrencyImpl:ConvertCurrency{
    
    private let endPoint : CurrencyConverterEndpoint
    
    init(endPoint:CurrencyConverterEndpoint){
        self.endPoint = endPoint
    }
    
    func convertCurrency(fromAmount: String, fromCurrency: String, toCurrency: String) -> Promise<CurrencyAPIResponse?> {
        
        guard let fromCurrencyType = SupportedCurrencyTypeAPIModel.init(rawValue: fromCurrency),
              let toCurrencyType = SupportedCurrencyTypeAPIModel(rawValue: toCurrency)else{
            return Promise.init(error: GenericAPIError.unSupportedCurrency)
        }
        
        let apiRequestModel = CurrencyRequestAPIModel(fromAmount: fromAmount,
                                                      fromCurrency: fromCurrencyType,
                                                      toCurrency: toCurrencyType)
        
        return endPoint.convertCurrency(currencyRequestAPIModel: apiRequestModel)
    }
    
}
