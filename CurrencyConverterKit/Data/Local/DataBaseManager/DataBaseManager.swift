//
//  DataBaseManager.swift
//  CurrencyConverterKit
//
//  Created by Mehmet Baykar on 8/8/22.
//

import PromiseKit
import RealmSwift


public enum DataBaseManagerError:Error{
    case couldNotOpen
    case couldNotWrite
    case unsufficientBalance
    case custom(reason:String)
    
   public var description:String{
        switch self {
        case .couldNotOpen:
            return "couldNotOpen to database"
        case .couldNotWrite:
            return "couldNotWrite to database"
        case .unsufficientBalance:
            return "unsufficient Balance"
        case .custom(let reason):
            return "Custom Error Reason:\(reason)"
        }
    }
}

public protocol DataBaseManager {
    
    func start() -> Promise<Void>
    
    func getObjects() -> Promise<[AvailableCurrency]>
    
    func addItem(item: AvailableCurrency) -> Promise<Void>
    
    func updateUserBalance(sellValue: Double,
                           sellCurrency: String,
                           buyValue: Double,
                           buyCurrency: String,
                           comissionFee: Double) -> Promise<Void>

}

final class DataBaseManagerImpl: DataBaseManager {
    
    private let realm = try! Realm()
    
    func start() -> Promise<Void> {
        return Promise{resolver in
            
            let realm = try? Realm()
           
            if realm != nil{
                resolver.fulfill(())
            }else{
                resolver.reject(DataBaseManagerError.couldNotOpen)
            }
        }
    }
    
    func getObjects() -> Promise<[AvailableCurrency]> {
        return Promise{ resolver in
            let realmResults = realm.objects(AvailableCurrency.self)
            resolver.fulfill(Array(realmResults))
        }
    }
    
    func addItem(item: AvailableCurrency) -> Promise<Void> {
        return Promise{ resolver in
            try! realm.write {
                realm.add(item)
                resolver.fulfill(())
            }
        }
    }
    
    func updateUserBalance(sellValue: Double,
                           sellCurrency: String,
                           buyValue: Double,
                           buyCurrency: String,
                           comissionFee: Double) -> Promise<Void> {
        
        
        return Promise {resolver in
            
            let totalSellValue = sellValue + comissionFee
            
            let availableSellCurrency = realm.objects(AvailableCurrency.self).filter("currencyName = %@", sellCurrency).first
            
            guard availableSellCurrency?.currencyAmount ?? 0.0 >= totalSellValue else {
                resolver.reject(DataBaseManagerError.unsufficientBalance)
                return
            }
            
            try! realm.write {
                availableSellCurrency?.currencyAmount -= sellValue
            }
            
            let availableBuyCurrency = realm.objects(AvailableCurrency.self).filter("currencyName = %@", buyCurrency).first
            try! realm.write {
                
                availableBuyCurrency?.currencyAmount += buyValue
            }
            
            UserDefaults.standard.freeTransactionAmount = UserDefaults.standard.freeTransactionAmount - 1
            
            resolver.fulfill(())
        }
        
    }

}


