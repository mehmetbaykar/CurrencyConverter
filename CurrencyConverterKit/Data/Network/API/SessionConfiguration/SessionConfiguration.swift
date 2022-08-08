//
//  SessionConfiguration.swift
//  CurrencyConverterKit
//
//  Created by Mehmet Baykar on 8/8/22.
//

import Foundation
import Alamofire

protocol SessionConfiguration {
     var sessionManager:Session { get }
}

final class RemoteSessionConfiguration:BaseObject, SessionConfiguration {

    let sessionManager: Session = {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .reloadIgnoringLocalCacheData
    configuration.urlCache = nil
    
    let sessionManager = Session(configuration: configuration, startRequestsImmediately: true)
    return sessionManager
  }()
}
