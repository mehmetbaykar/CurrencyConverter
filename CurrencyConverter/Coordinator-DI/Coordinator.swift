

//
//  Coordinator.swift
//  CurrencyConverter
//
//  Created by Mehmet Baykar on 8/8/22.
//

import UIKit

final class Coordinator{

    static var shared: Coordinator {
        return (UIApplication.shared.delegate as! AppDelegate).coordinator
    }
    
    var keyWindow:UIWindow?{
        return UIApplication.shared.mainKeyWindow
    }
    
    var baseNavigationController:UINavigationController{
        return keyWindow?.rootViewController as! UINavigationController
    }
    
    var compositionRoot: CompositionRoot {
        return CompositionRoot.sharedInstance
    }
    
   
}

private extension Coordinator{
    func push(vc:UIViewController,shouldKillPrevious : Bool = false){
        if shouldKillPrevious{
            baseNavigationController.setViewControllers([vc], animated: true)
        }else{
            baseNavigationController.pushViewController(vc, animated: true)
        }
       
    }
}


extension UIApplication{
    
    var mainKeyWindow:UIWindow?{
        if #available(iOS 13.0, *), supportsMultipleScenes{
            return UIApplication.shared.connectedScenes
                .filter { $0.activationState == .foregroundActive }
                .first(where: { $0 is UIWindowScene })
                .flatMap({ $0 as? UIWindowScene })?.windows
                .first(where: \.isKeyWindow)
        } else {
            return keyWindow
            
        }
    }
}
