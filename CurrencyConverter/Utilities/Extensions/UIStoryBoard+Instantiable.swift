//
//  UIStoryBoard+Instantiable.swift
//  CurrencyConverter
//
//  Created by Mehmet Baykar on 8/8/22.
//

import UIKit

protocol StringConvertible {
    var rawValue: String {get}
}

enum StoryboardName: String, StringConvertible {
    case main = "Main"
}

protocol Instantiable: AnyObject {
    static var storyboardName: StringConvertible {get}
}

extension Instantiable {
    static func instantiateFromStoryboard() -> Self {
        return instantiateFromStoryboardHelper()
    }

    private static func instantiateFromStoryboardHelper<T>() -> T {
        let identifier = String(describing: self)
        let storyboard = UIStoryboard(name: storyboardName.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier) as! T
    }
}

//MARK: -

extension String: StringConvertible { // allow string as storyboard name
    var rawValue: String {
        return self
    }
}
