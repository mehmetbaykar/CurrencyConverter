//
//  CurrencyConverterRouterBuilder.swift
//  CurrencyConverterKit
//
//  Created by Mehmet Baykar on 8/8/22.
//

import Foundation
import Alamofire

struct CurrencyConverterRouterBuilder: URLRequestConvertible {
    
    let apiRouter: CurrencyConverterAPIRouter
    
    func headers() -> HTTPHeaders {
        var defaultHeadersDictionary = [
            "Content-Type" : "application/json"
        ]
        
        if let additionalHeaders = apiRouter.additionalHeaders {
            let additionalHeadersDictionary = additionalHeaders.dictionary
            additionalHeadersDictionary.forEach { (key, value) in
                defaultHeadersDictionary[key] = value
            }
        }
        return HTTPHeaders(defaultHeadersDictionary)
    }
    
    func asURLRequest() throws -> URLRequest {
        var url:URL
        
        do {
            url = try apiRouter.baseURL.asURL()
        }catch{
            throw GenericAPIError.invalidUrl
        }
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(apiRouter.path))
        urlRequest.httpMethod = apiRouter.method.rawValue
        urlRequest.timeoutInterval = apiRouter.timeout
        urlRequest.headers = headers()
        
        
        if let body = apiRouter.body {
            do {
                let data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                urlRequest.httpBody = data
            } catch {
                throw GenericAPIError.invalidData
            }
        }
        
        if let parameters = apiRouter.parameters {
            do{
                urlRequest = try apiRouter.encoding.encode(urlRequest, with: parameters)
            }catch{
                throw GenericAPIError.invalidEncoding
            }
            
        }
        print("urlRequest: \(urlRequest)")
        
        return urlRequest
    }
    
}
