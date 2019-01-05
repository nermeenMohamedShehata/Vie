//
//  AlertView.swift
//
//  Created by Meseery on 9/12/17.
//  Copyright © 2017 Joi. All rights reserved.
//

import UIKit

final class AlertView {
    /**
     A builder function to make an UIAlertController.
     
     - parameter title:   Title will appear in AlertView
     - parameter message: Message in alert view
     - parameter style:   You can choose .ActionSheet or .Alert
     
     - returns: an UIAlertController, which can be config action button by DSL function below.
     */
    static func alert(title: String? = nil, message: String? = nil, style: UIAlertController.Style = .alert) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style
        )
        return alert
    }
    
    static func showAlert(WithMessage msg:String){
        let alert = AlertView.alert(title: L10n.sorryTitle,
                                    message: msg)
        /*
        if let topController = UIApplication.topViewController() {
            topController.present(alert, animated: true) {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {[weak alert] in
                    alert?.dismiss(animated: true, completion: nil)
                    
                })
            }
        }
        */
        
        
        alert.customShow(animated: true, vibrate: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {[weak alert] in
                alert?.dismiss(animated: true, completion: nil)
            })
        })
        
    }
    
}

extension UIAlertController {
    
    /**
     It add a cancel button into Alert View, which will close the Alert when touch on that.
     
     - parameter title:   Label of cancel button, integrated with LocalizedString.
     - parameter handler: Closure which will be notified when cancel button be tapped.
     
     - returns: an UIAlertController
     */
    func willCancel(title: String = "Cancel", handler: ((UIAlertAction) -> ())? = nil) -> UIAlertController {
        return will(title: title, style: .cancel, handler: handler)
    }
    
    /**
     Add a button into Alert View.
     
     - parameter title:   Label of button. Integrated with LocalizedString
     - parameter style:   It can be .Default, .Cancel or .Destructive
     - parameter handler: Be notified when this button be tapped
     
     - returns: an UIAlertController
     */

    func will(title: String, style: UIAlertAction.Style = .default, handler: (( _ alertAction: UIAlertAction) -> Void)? = nil) -> UIAlertController {
        self.addAction(UIAlertAction(title: title, style: style, handler: handler))
        return self
    }
    
    /**
     Show the alert view on screen.
     
     - parameter viewController: The ViewController what you want to show AlertView above.
     - parameter animated:       Be true if you want to animate the presenting of AlertView
     - parameter completion:     Be notified when presentation finished
     */
    func present(on viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        viewController.present(self, animated: animated, completion: completion)
    }
}
//MARK :- Removed
extension UIAlertController{
    /*
    static func showAlert(WithMessage msg:String,options:String ...){
        let alert = AlertView.alert(title: L10n.sorryTitle,
                                    message: msg)
        for option in options {
            alert.addAction(option)
        }
        /*
         if let topController = UIApplication.topViewController() {
         topController.present(alert, animated: true) {
         DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {[weak alert] in
         alert?.dismiss(animated: true, completion: nil)
         
         })
         }
         }
         */
        
        alert.customShow(animated: true, vibrate: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {[weak alert] in
                alert?.dismiss(animated: true, completion: nil)
            })
        })
        
    }
    */
}
