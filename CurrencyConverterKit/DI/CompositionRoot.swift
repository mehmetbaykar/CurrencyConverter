//
//  CompositionRoot.swift
//  CurrencyConverterKit
//
//  Created by Mehmet Baykar on 8/8/22.
//

import Foundation

final public class CurrencyConverterKitCompositionRoot{
    
    public static var shared = CurrencyConverterKitCompositionRoot()
    
    public static func reset() {
        shared = CurrencyConverterKitCompositionRoot()
    }
    
    lazy var sessionConfiguration:SessionConfiguration = {
        RemoteSessionConfiguration()
    }()
    
    lazy var apiEndPoint:CurrencyConverterEndpoint = {
        CurrencyConverterEndpointImpl(sessionConfiguration: sessionConfiguration)
    }()
    
    public lazy var resolveConvertCurrency:ConvertCurrency = {
        return ConvertCurrencyImpl(endPoint: apiEndPoint)
    }()
    
    public lazy var resolveDataBaseManager:DataBaseManager = {
        return DataBaseManagerImpl()
    }()
    
}
