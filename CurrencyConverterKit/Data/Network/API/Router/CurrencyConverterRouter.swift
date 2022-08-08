//
//  CurrencyConverterRouter.swift
//  CurrencyConverterKit
//
//  Created by Mehmet Baykar on 8/8/22.
//


import Alamofire

enum CurrencyConverterAPIRouter {
    
    case convertCurrent(requestAPI:CurrencyRequestAPIModel)
    
    var baseURL: String {
        switch self {
        default: return CurrencyConverterConstants.baseURL
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .convertCurrent( _ ): return .get
        }
    }
    
    var path: String {
        switch self {
        case .convertCurrent(let apiRequestModel):
            return "/currency/commercial/exchange/\(apiRequestModel.fromAmount)-\(apiRequestModel.fromCurrency.code)/\(apiRequestModel.toCurrency.code)/latest"
        }
    }
    
    var encoding: ParameterEncoding {
        switch method {
        default: return URLEncoding.default
        }
    }
    
    var parameters: Parameters? {
        switch self {
        default: return nil
        }
    }
    
    var body: Parameters? {
        switch self {
        default:return nil
        }
    }
    
    var additionalHeaders: HTTPHeaders? {
        switch self {
        default:return nil
        }
    }
    
    var timeout: TimeInterval {
        switch self {
        default: return 20
        }
    }
}

