//
//  Alamofire+PromiseKit.swift
//  CurrencyConverterKit
//
//  Created by Mehmet Baykar on 8/8/22.
//

import PromiseKit
import Alamofire

extension Alamofire.DataRequest {
    
    public func response(_: PMKNamespacer, queue: DispatchQueue = .main) -> Promise<(URLRequest, HTTPURLResponse, Data)> {
        return Promise { seal in
            response(queue: queue) { rsp in
                if let error = rsp.error {
                    seal.reject(error)
                } else if let a = rsp.request, let b = rsp.response, let c = rsp.data {
                    seal.fulfill((a, b, c))
                } else {
                    seal.reject(PMKError.invalidCallingConvention)
                }
            }
        }
    }
    
    
    public func responseData(queue: DispatchQueue = .main) -> Promise<(data: Data, response: PMKAlamofireDataResponse)> {
        return Promise { seal in
            responseData(queue: queue) { response in
                switch response.result {
                case .success(let value):
                    seal.fulfill((value, PMKAlamofireDataResponse(response)))
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    
    public func responseString(queue: DispatchQueue = .main) -> Promise<(string: String, response: PMKAlamofireDataResponse)> {
        return Promise { seal in
            responseString(queue: queue) { response in
                switch response.result {
                case .success(let value):
                    seal.fulfill((value, PMKAlamofireDataResponse(response)))
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    
    public func responseJSON(queue: DispatchQueue = .main, options: JSONSerialization.ReadingOptions = .allowFragments) -> Promise<(json: Any, response: PMKAlamofireDataResponse)> {
        return Promise { seal in
            responseData(queue: queue) { response in
                switch response.result {
                case .success(let dataValue):
                    do {
                        let json = try JSONSerialization.jsonObject(with: dataValue, options: options)
                        seal.fulfill((json, PMKAlamofireDataResponse(response)))
                    } catch {
                        seal.reject(error)
                    }
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
    
    public func responseDecodable<T,U>(errorType:U.Type,
                                       queue: DispatchQueue = .main,
                                       decoder: JSONDecoder = JSONDecoder())-> Promise<T?> where T:Decodable,U:Decodable, U:Error {
       
        return responseJSON().then { json, response -> Promise<T?> in
            
            if let statusCode = response.response?.statusCode {
                if let data = response.data {
                    let decoder = JSONDecoder()
                    decoder.dateDecodingStrategy = .iso8601
                    switch statusCode {
                    case 200 ..< 299 :
                        let model = try data.transform(with: decoder, to: T.self)
                        return Promise.value(model)
                    case 300 ..< 599:
                        let model = try data.transform(with: decoder, to: errorType.self)
                        return Promise.init(error: model)
                    default:
                        return Promise.init(error: GenericAPIError.unknown(reason: "StatusCode:\(statusCode)"))
                    }
                } else if statusCode == 200 {
                    return Promise.value(nil)
                }
            }
            return Promise.value(nil)
        }
    }
    
    
    public func responseDecodable<T: Decodable>(_ type: T.Type, queue: DispatchQueue = .main, decoder: JSONDecoder = JSONDecoder()) -> Promise<T> {
        return Promise { seal in
            responseData(queue: queue) { response in
                switch response.result {
                case .success(let value):
                    do {
                        seal.fulfill(try decoder.decode(type, from: value))
                    } catch {
                        seal.reject(error)
                    }
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}

extension Alamofire.DownloadRequest {
    public func response(_: PMKNamespacer, queue: DispatchQueue = .main) -> Promise<DownloadResponse<URL?,AFError>> {
        return Promise { seal in
            response(queue: queue) { response in
                if let error = response.error {
                    seal.reject(error)
                } else {
                    seal.fulfill(response)
                }
            }
        }
    }
    
    
    public func responseData(queue: DispatchQueue = .main) -> Promise<DownloadResponse<Data,AFError>> {
        return Promise { seal in
            responseData(queue: queue) { response in
                switch response.result {
                case .success:
                    seal.fulfill(response)
                case .failure(let error):
                    seal.reject(error)
                }
            }
        }
    }
}

public struct PMKAlamofireDataResponse {
    public init<T,E>(_ rawrsp: Alamofire.DataResponse<T,E>) {
        request = rawrsp.request
        response = rawrsp.response
        data = rawrsp.data
    }
    
    public let request: URLRequest?
    
    public let response: HTTPURLResponse?
    
    public let data: Data?
}

private extension Data {
    func transform<T>(with decoder: JSONDecoder, to model: T.Type) throws -> T where T: Decodable {
        return try decoder.decode(model, from: self)
    }
}
