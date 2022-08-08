//
//  BaseObject.swift
//  CurrencyConverterKit
//
//  Created by Mehmet Baykar on 8/8/22.
//

import Foundation

///Could be used to track Memory Leaks
open class BaseObject{
    deinit{
        print("\(String(describing: self)):Has been deinited")
    }
}

