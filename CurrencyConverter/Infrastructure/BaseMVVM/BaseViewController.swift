//
//  BaseViewController.swift
//  CurrencyConverter
//
//  Created by Mehmet Baykar on 8/8/22.
//

import Foundation
import RxSwift
import UIKit
import IQKeyboardManagerSwift

class BaseViewController<T>: UIViewController,
                             BaseNotificationUI where T: BaseViewModel {
    
    var disposeBag = DisposeBag()
    
    var viewModel: T!
    
    var isKeyboardManagerEnabled = true{
        didSet{
            IQKeyboardManager.shared.enable = self.isKeyboardManagerEnabled
            IQKeyboardManager.shared.enableAutoToolbar = self.isKeyboardManagerEnabled
            IQKeyboardManager.shared.shouldResignOnTouchOutside = self.isKeyboardManagerEnabled
            IQKeyboardManager.shared.shouldShowToolbarPlaceholder = !self.isKeyboardManagerEnabled
        }
    }
    
    deinit {
        print("\(String(describing: self)):Has been deinited")
        NotificationCenter.default.removeObserver(self)
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    public var isAControllerPresented:Bool{
        return self.presentedViewController != nil
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel.viewDidLoad()
        
        print("\(String(describing: self)):New Controler is Loaded")
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        bindWithObserver()
        bindNotifications()
        viewModel.viewWillAppear()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.viewDidAppear()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.viewWillDisappear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.viewDidDisappear()
    }
    
    @objc func willEnterForeground() {
        viewModel.willEnterForeground()
    }
    
    @objc func didActive() {
        viewModel.didActive()
    }
    
    @objc func willResign() {
        viewModel.willResign()
    }
    
    @objc func didEnterBackground() {
        viewModel.didEnterBackground()
    }
    
    public func bindWithObserver() {}
    
    public func bindNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willResign), name: UIApplication.willResignActiveNotification, object: nil)
    }
}
