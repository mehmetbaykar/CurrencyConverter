//
//  CurrenctConverterEndpoint.swift
//  CurrencyConverterKit
//
//  Created by Mehmet Baykar on 8/8/22.
//

import Foundation
import PromiseKit
import AlamofireNetworkActivityLogger

public protocol CurrencyConverterEndpoint{
    func convertCurrency(currencyRequestAPIModel:CurrencyRequestAPIModel) -> Promise<CurrencyAPIResponse?>
}

final class CurrencyConverterEndpointImpl:BaseObject,CurrencyConverterEndpoint{
    
    private let sessionConfiguration: SessionConfiguration
    
    deinit{
        if !CurrencyConverterConstants.isUsingProductionService{
            AlamofireNetworkActivityLogger.NetworkActivityLogger.shared.stopLogging()
        }
    }
    
    init(sessionConfiguration:SessionConfiguration){
        self.sessionConfiguration = sessionConfiguration
        
        if !CurrencyConverterConstants.isUsingProductionService{
            AlamofireNetworkActivityLogger.NetworkActivityLogger.shared.startLogging()
        }
       
    }
    
    private func request<T:Decodable>(router:CurrencyConverterRouterBuilder) -> Promise<T?>{
        return self.sessionConfiguration.sessionManager.request(router)
            .cURLDescription { description in
                print("API Request Description:\(description)")
            }
            .responseDecodable(errorType: GenericAPIError.self)
    }
    
    func convertCurrency(currencyRequestAPIModel: CurrencyRequestAPIModel) -> Promise<CurrencyAPIResponse?> {
        let router = CurrencyConverterRouterBuilder(apiRouter: .convertCurrent(requestAPI: currencyRequestAPIModel))
        
        return self.request(router: router)
    }
    
    
}
