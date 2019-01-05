//
//  UIAlertController+Extensions.swift
//  Joi
//
//  Created by Nermeen on 8/26/18.
//  Copyright © 2018 Enhance. All rights reserved.
//

import Foundation
import UIKit
import AudioToolbox

// MARK: - Methods
public extension UIAlertController {
    
    /// SwifterSwift: Present alert view controller in the current view controller.
    ///
    /// - Parameters:
    ///   - animated: set true to animate presentation of alert controller (default is true).
    ///   - vibrate: set true to vibrate the device while presenting the alert (default is false).
    ///   - completion: an optional completion handler to be called after presenting alert controller (default is nil).
    public func customShow(animated: Bool = true, vibrate: Bool = false, completion: (() -> Void)? = nil) {
        
        if let topController = UIApplication.topViewController() {
            topController.present(self, animated: animated, completion: completion)
            if vibrate {
                AudioServicesPlayAlertSound(kSystemSoundID_Vibrate)
            }
        }
        
    }
    @objc func hideAlertController() {
        self.dismiss(animated: false, completion: nil)
    }
  
}

