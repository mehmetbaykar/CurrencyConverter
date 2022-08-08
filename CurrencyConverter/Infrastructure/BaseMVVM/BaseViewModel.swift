//
//  BaseViewModel.swift
//  CurrencyConverter
//
//  Created by Mehmet Baykar on 8/8/22.
//

import Foundation
import CurrencyConverterKit

protocol BaseView:BaseNotificationUI{}

open class BaseViewModel:NSObject{
    
    weak var view:BaseView? = nil
    
    deinit{
        print("\(String(describing: self)):Has been deinited")
        NotificationCenter.default.removeObserver(self)
    }
    
    init(view:BaseView){
        self.view = view
        super.init()
    }
    
    func viewDidLoad() { }
    
    func viewWillAppear() { }
    
    func viewWillDisappear() { }
    
    func viewDidDisappear() { }
    
    func viewDidAppear(){ }
    
    func willEnterForeground() { }
    
    func didEnterBackground() { }
    
    func willResign(){ }
    
    func didActive() { }
    
}
