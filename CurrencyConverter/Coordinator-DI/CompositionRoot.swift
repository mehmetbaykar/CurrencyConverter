//
//  CompositionRoot.swift
//  CurrencyConverter
//
//  Created by Mehmet Baykar on 8/8/22.
//

import Foundation
import CurrencyConverterKit

final class CompositionRoot{
    
    static var currencyConverterkitCompositionRoot = CurrencyConverterKitCompositionRoot.shared
    static var sharedInstance = CompositionRoot()
    
    func makeMainScreen() -> CurrencyConverterViewController{
        
        let mainScreen = CurrencyConverterViewController.instantiateFromStoryboard()
        let viewModel = CurrencyConverterViewModel(databaseManager:CompositionRoot.currencyConverterkitCompositionRoot.resolveDataBaseManager,
                                                      convertCurrency: CompositionRoot.currencyConverterkitCompositionRoot.resolveConvertCurrency,
                                                      view: mainScreen)
        mainScreen.viewModel = viewModel
        
        return mainScreen
        
    }
    
}
