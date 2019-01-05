                //
//  AppError.swift
//  Vie
//
//  Created by Meseery on 9/25/17.
//  Copyright © 2017 Enhance. All rights reserved.
//

import UIKit
import Siesta

struct AppError {
    var errorCode : Int?
    var errorMessage : String?
    var errorFriendlyMessage : String?
    
    init(errorCode:Int?, errorMessage:String?) {
        self.errorMessage = errorMessage
        self.errorCode = errorCode
    }
    
    init(error:RequestError) {
        self.errorCode = error.httpStatusCode
        self.errorMessage = error.userMessage
        if let errors = error.entity?.jsonDict["errors"] as? [String:Array<String>] {
            let messages = errors.values.joined().joined(separator: "\n")
            self.errorFriendlyMessage = messages
        }
        
    }
    let DismissAllAlertsNotification = Notification.Name("DismissAllAlertsNotification")

    func show(){
        var message = L10n.errorInConnection
        if let friendlyMsg = self.errorFriendlyMessage {
            message = friendlyMsg
        }
        let alert = AlertView.alert(title: L10n.sorryTitle,
                                    message: message)

        NotificationCenter.default.addObserver(alert, selector: #selector(alert.hideAlertController), name: DismissAllAlertsNotification, object: nil)

        alert.customShow(animated: true, vibrate: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {[weak alert] in
                NotificationCenter.default.post(name: self.DismissAllAlertsNotification, object: nil)
            })
        })
    }
    
    static func showErrors(_ errors:[String]){
        let message = errors.joined(separator: "\n")
        let alert = AlertView.alert(title: L10n.sorryTitle,
                                    message: message)
        
   
        alert.customShow(animated: true, vibrate: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {[weak alert] in
                alert?.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    static func showErrors(_ errors:[AppError]){
        let message = errors.flatMap({$0.errorFriendlyMessage}).joined(separator: "\n")
        let alert = AlertView.alert(title: L10n.sorryTitle,
                                    message: message)
        
        alert.customShow(animated: true, vibrate: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {[weak alert] in
                alert?.dismiss(animated: true, completion: nil)
            })
        })
    }
    
}
