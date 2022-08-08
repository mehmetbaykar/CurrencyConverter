//
//  UserDefaults+Extension.swift
//  CurrencyConverterKit
//
//  Created by Mehmet Baykar on 8/8/22.
//

import Foundation


public extension UserDefaults {
    
    private struct UserDefaultsConstants{
        static let FREE_TIME = "FreeTime"
        static let LAUNCHED_BEFORE = "launchedBefore"
    }
    
    var freeTransactionAmount : Int {
        
        get{
            return integer(forKey: UserDefaultsConstants.FREE_TIME)
        }
        set{
            set(newValue, forKey: UserDefaultsConstants.FREE_TIME)
        }
    }
    
    var isLaunchedBefore : Bool {
        get{
            return bool(forKey: UserDefaultsConstants.LAUNCHED_BEFORE)
        }
        set{
            set(newValue, forKey: UserDefaultsConstants.LAUNCHED_BEFORE)
        }
    }
    
}

