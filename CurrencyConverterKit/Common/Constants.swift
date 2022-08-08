//
//  Constants.swift
//  CurrencyConverterKit
//
//  Created by Mehmet Baykar on 8/8/22.
//

import Foundation

public class CurrencyConverterConstants:BaseObject{
    
    private enum Environment {
        case production
        case staging
    }
    
    private static var environment: Environment = {
#if DEBUG
        return .staging
#else
        return .production
#endif
    }()
    
    private static var shared:CurrencyConverterConstantsProtocol{
        switch environment {
        case .production:
            return CurrencyConverterConstantsProduction()
        case .staging:
            return CurrencyConverterConstantsStaging()
        }
    }
    
    private override init(){}
    
    public static var isUsingProductionService: Bool {
        return environment == .staging
    }
    
    public static var baseURL: String{ return shared.baseURL }
    
    public static var commissionFee: Double{ return shared.comissionFee }
    
}


private protocol CurrencyConverterConstantsProtocol: AnyObject {
    var baseURL:String { get }
    var comissionFee:Double { get }
}

private class CurrencyConverterConstantsProduction:CurrencyConverterConstantsProtocol{
    
    var baseURL: String{
        return "http://api.evp.lt"
    }
    
    var comissionFee: Double{
        return 0.007
    }
    
    
    
}

private class CurrencyConverterConstantsStaging:CurrencyConverterConstantsProtocol{
    
    var baseURL: String{
        return "http://api.evp.lt"
    }
    
    var comissionFee: Double{
        return 0.007
    }
    
}
