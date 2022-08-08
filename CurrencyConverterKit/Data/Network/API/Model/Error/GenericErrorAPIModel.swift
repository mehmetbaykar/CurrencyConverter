//
//  GenericErrorAPIModel.swift
//  CurrencyConverterKit
//
//  Created by Mehmet Baykar on 8/8/22.
//

enum GenericAPIError: Error,Codable {
    case invalidUrl
    case invalidData
    case invalidResponse
    case invalidEncoding
    case unSupportedCurrency
    case unknown(reason:String)
    
    var description: String {
        switch self {
        case .invalidUrl:
            return "Strings.Error.invalidUrl"
        case .invalidData:
            return "Strings.Error.invalidData"
        case .invalidResponse:
            return "Strings.Error.invalidResponse"
        case .invalidEncoding:
            return ""
        case .unSupportedCurrency:
            return "Select"
        case .unknown(reason: let reason):
            return reason
       
            
        }
    }
}
