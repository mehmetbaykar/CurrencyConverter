//
//  AppDelegate.swift
//  CurrencyConverter
//
//  Created by Mehmet Baykar on 8/8/22.
//

import UIKit
import CurrencyConverterKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private (set) lazy var coordinator: Coordinator = {
        Coordinator()
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        _ = CompositionRoot.currencyConverterkitCompositionRoot.resolveDataBaseManager.start().ensure {
            
            if !UserDefaults.standard.isLaunchedBefore {
                self.initFirstLaunch()
            }
            self.setupWindow()
            
        }.catch({ error in
            print("Error opening the database\(error.localizedDescription)")
        })
        
      
        return true
    }
    
    private func setupWindow(){
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        guard let window = window else {
            return
        }
        
        window.rootViewController = UINavigationController(rootViewController: CompositionRoot.sharedInstance.makeMainScreen())
        
        self.preventMultipleTouch()
        
        window.makeKeyAndVisible()
    }
    
    private func preventMultipleTouch(){
        UIView.appearance().isExclusiveTouch = true
    }
    
    
    private func initFirstLaunch() {
        UserDefaults.standard.isLaunchedBefore = true
        
        UserDefaults.standard.freeTransactionAmount = 5
        
        _ = CompositionRoot.currencyConverterkitCompositionRoot.resolveDataBaseManager.addItem(item: AvailableCurrency(currencyName: SupportedCurrencyTypeAPIModel.euro.code, amount: 800.0))
        
       _ =  CompositionRoot.currencyConverterkitCompositionRoot.resolveDataBaseManager.addItem(item: AvailableCurrency(currencyName: SupportedCurrencyTypeAPIModel.dollar.code, amount: 0.0))
        _ = CompositionRoot.currencyConverterkitCompositionRoot.resolveDataBaseManager.addItem(item: AvailableCurrency(currencyName: SupportedCurrencyTypeAPIModel.yen.code, amount: 0.0))
           
    }
}

