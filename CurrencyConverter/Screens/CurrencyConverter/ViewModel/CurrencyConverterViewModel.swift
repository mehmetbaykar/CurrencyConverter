//
//  CurrencyConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Mehmet Baykar on 8/8/22.
//

import Foundation
import RxSwift
import RxCocoa
import CurrencyConverterKit

class CurrencyConverterViewModel:BaseViewModel{

    var shouldUpdateBalance = BehaviorRelay<Bool>(value: false)
    var supportedCurrency = BehaviorRelay<[AvailableCurrency]>(value: [])
    var apiConvertSuccess = PublishSubject<CurrencyAPIResponse>()
    var sellCurrency = BehaviorRelay<String>(value: SupportedCurrencyTypeAPIModel.euro.code)
    var buyCurrency = BehaviorRelay<String>(value: SupportedCurrencyTypeAPIModel.dollar.code)
    var amount = BehaviorRelay<String>(value: "100")

    let databaseManager: DataBaseManager
    let convertCurrency: ConvertCurrency

    init(databaseManager: DataBaseManager,
         convertCurrency: ConvertCurrency,
         view:BaseView) {
        self.databaseManager = databaseManager
        self.convertCurrency = convertCurrency
        super.init(view: view)
        loadCurrencies()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }

    private func loadCurrencies(){
        databaseManager.getObjects().done({ availabelCurrency in
            self.supportedCurrency.accept(availabelCurrency)
        }).catch { error in
            self.view?.showNotification(with: .error, text: error.localizedDescription, position: .center, action: nil, actionName: nil)
            print("Error on loadCurrencies :\(error.localizedDescription)")
        }
    }
    
    func onTapSubmit() {
        convertCurrency(shouldUpdateBalance: true)
    }
    func onAmountTextFieldEditingChanged() {
        convertCurrency()
    }

    private func convertCurrency(shouldUpdateBalance: Bool = false) {
        
        
        guard amount.value.isNumeric else{
            return
        }
        convertCurrency.convertCurrency(fromAmount: amount.value,
                                        fromCurrency: sellCurrency.value,
                                        toCurrency: buyCurrency.value).done { response in
            if let response = response {
                
               self.apiConvertSuccess.onNext(response)
                
                if shouldUpdateBalance{
                    
                    let comissionFee = self.calcuteComissionFee(sellValue: self.amount.value.doubleValue)
                    
                    self.databaseManager.updateUserBalance(sellValue: ((self.amount.value.doubleValue)),
                                                           sellCurrency: self.sellCurrency.value,
                                                           buyValue: response.amount.doubleValue,
                                                           buyCurrency: response.currency,
                                                           comissionFee: comissionFee)
                    .then({ _ in
                        self.databaseManager.getObjects()
                    }).done { objects in
                        
                        self.supportedCurrency.accept(objects)
                        
                        self.view?.showNotification(with: .success,
                                                    text: "You have converted \(self.amount) \(self.sellCurrency) to \(response.amount) \(response.currency). Comission Fee: \(comissionFee)",
                                               position: .center,
                                               action: nil,
                                               actionName: "OK")
                    }.catch { error in
                        
                        if let error = error as? DataBaseManagerError {
                            self.view?.showNotification(with: .error, text: error.description,
                                                        position: .top,
                                                        action: nil,
                                                        actionName: nil)
                        }else{
                            self.view?.showNotification(with: .error,
                                                        text: error.localizedDescription,
                                                   position: .center,
                                                   action: nil,
                                                   actionName: "OK")
                        }
                    }
                }
            }
        }.catch { error in
            self.view?.showNotification(with: .error, text: error.localizedDescription, position: .center, action: nil, actionName: nil)
            print("Error on convertCurrency :\(error.localizedDescription)")
        }
    }

    // MARK: - Calcute Comission Fee

    func calcuteComissionFee(sellValue: Double) -> Double {
        let transactionCount = UserDefaults.standard.freeTransactionAmount >= 5
        if transactionCount {
            return sellValue * CurrencyConverterConstants.commissionFee
        } else {
            return 0.0
        }
    }

}
