//
//  BaseNotificationUI.swift
//  CurrencyConverter
//
//  Created by Mehmet Baykar on 8/8/22.
//

import SwiftMessages
import UIKit


typealias NotificationType = Theme
typealias NotificationPosition = SwiftMessages.PresentationStyle

protocol BaseNotificationUI:AnyObject{
    func showNotification(with type:NotificationType,
                          text:String,
                          position:NotificationPosition,
                          action:(() -> Void)?,
                          actionName:String?)
    func dismissAll()
    func dismissWith(identifier:String)
}

extension BaseNotificationUI{
    
    var defaultConfig:SwiftMessages.Config{
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .window(windowLevel: UIWindow.Level.statusBar)
        config.duration = .forever
        config.dimMode = .blur(style: .regular, alpha: 1.0, interactive: true)
        
        return config
    }
    
    
    func showNotification(with type:NotificationType,
                          text:String,
                          position:NotificationPosition,
                          action:(() -> Void)?,
                          actionName:String?) {
        var messageView : MessageView!
        
        switch type {
            
        case .error:
            
            messageView = MessageView.viewFromNib(layout: .cardView)
            messageView.configureContent(title: "Error", body: text)
            messageView.button?.setTitle("Retry", for: .normal)
            
        case .success:
            
            messageView = MessageView.viewFromNib(layout: .cardView)
            messageView.configureContent(title: "Success", body: text)
            messageView.button?.setTitle("OK", for: .normal)
            
            
        case .warning:
            
            messageView = MessageView.viewFromNib(layout: .cardView)
            messageView.configureContent(title: "Warning", body: text)
            messageView.button?.setTitle("Understood", for: .normal)
            
            
        default:fatalError("Not implemented yet")
            
        }
        
        messageView.configureTheme(type)
        messageView.configureDropShadow()
        
        messageView.button?.isHidden = (actionName == nil) ? true : false
        
        
        messageView.buttonTapHandler = { _ in
            
            DispatchQueue.main.async {
                SwiftMessages.hide(id:text)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                action?()
            }
            
        }
        
        messageView.id = text
        
        var config = defaultConfig
        config.presentationStyle = position
        
        SwiftMessages.show(config: config, view: messageView)
        
        
    }
    
    func dismissWith(identifier:String){
        SwiftMessages.hide(id:identifier)
    }
    
    func dismissAll(){
        SwiftMessages.hideAll()
    }
    
}
