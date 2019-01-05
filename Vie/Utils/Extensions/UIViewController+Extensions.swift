//
//  UIViewController+JOIAdditions.swift
//  Joi
//
//  Created by Meseery on 10/16/17.
//  Copyright © 2017 Enhance. All rights reserved.
//

import UIKit
let DismissAllAlertsNotification = Notification.Name("DismissAllAlertsNotification")
extension UIViewController {
    
        var previousViewController:UIViewController?{
            if let controllersOnNavStack = self.navigationController?.viewControllers{
                let n = controllersOnNavStack.count
                //if self is still on Navigation stack
                if controllersOnNavStack.last === self, n > 1{
                    return controllersOnNavStack[n - 2]
                }else if n > 0{
                    return controllersOnNavStack[n - 1]
                }
            }
            return nil
        }
    
    func isModal() -> Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController  {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        return false
    }
    
    func isNavigational() -> Bool {
        if self.navigationController != nil {
            return true
        }
        return false
    }

    func alert(title: String, message: String, buttonTitle:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let oke = UIAlertAction(title: buttonTitle, style: .default, handler: nil)
        alert.addAction(oke)
        self.present(alert, animated: true, completion: nil)
    }
    func alert(_ message:String){
       
        let alert = AlertView.alert(title: "",
                                    message: message)
        
        NotificationCenter.default.addObserver(alert, selector: #selector(alert.hideAlertController), name: DismissAllAlertsNotification, object: nil)
        
        alert.customShow(animated: true, vibrate: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3.0, execute: {[weak alert] in
                NotificationCenter.default.post(name: DismissAllAlertsNotification, object: nil)
            })
        })
    }
    func dismissWhenTappedAround()  {
        _ = UITapGestureRecognizer(addToView: self.view) {[weak self] in
            if (self?.isBeingPresented)! {
                self?.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func addEdgeBackSwipe() {
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.edgeSwipeAction(_:)))
        self.view.addGestureRecognizer(swipeRecognizer)
    }
    
    @objc func edgeSwipeAction(_ swipeGesture: UISwipeGestureRecognizer) {
        // Ratio of Main View to the swipe area
        let swipeAreaRatio : CGFloat = 10.0
        // Check the swipe is from left to right
        switch swipeGesture.direction {
        case UISwipeGestureRecognizer.Direction.right:
            // The swipe state must be 'ended'
            if swipeGesture.state == UIGestureRecognizer.State.ended {
                // Gets the first touch point of swipe action
                let touchPoint = swipeGesture.location(ofTouch: 0, in: self.view)
                // Checks that the swipe started from a point which is inside the
                // swipe area
                if touchPoint.x < self.view.frame.size.width / swipeAreaRatio {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        default:
            break
        }
    }
}

// MARK: - Keyboard Appearance

private var scrollViewKey : UInt8 = 0

extension UIViewController {
    
    public func setupKeyboardNotifcationListenerForScrollView(_ scrollView: UIScrollView) {
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillShow(_:)), name:  UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(UIViewController.keyboardWillHide(_:)), name:  UIResponder.keyboardWillHideNotification, object: nil)
        internalScrollView = scrollView
    }
    
    public func removeKeyboardNotificationListeners() {
        NotificationCenter.default.removeObserver(self, name:  UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name:  UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate var internalScrollView: UIScrollView? {
        get {
            return objc_getAssociatedObject(self, &scrollViewKey) as? UIScrollView
        }
        set(newValue) {
            objc_setAssociatedObject(self, &scrollViewKey, newValue, .OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo as! Dictionary<String, AnyObject>
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey]?.cgRectValue
        let keyboardFrameConvertedToViewFrame = view.convert(keyboardFrame!, from: nil)
        let options = UIView.AnimationOptions.beginFromCurrentState
        UIView.animate(withDuration: animationDuration, delay: 0, options:options, animations: { () -> Void in
            let insetHeight = ((self.internalScrollView?.frame.height)! + (self.internalScrollView?.frame.origin.y)!) - keyboardFrameConvertedToViewFrame.origin.y + 10
            self.internalScrollView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: insetHeight, right: 0)
            self.internalScrollView?.scrollIndicatorInsets  = UIEdgeInsets(top: 0, left: 0, bottom: insetHeight, right: 0)
        }) { (complete) -> Void in
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        let userInfo = (notification as NSNotification).userInfo as! Dictionary<String, AnyObject>
        let animationDuration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as! TimeInterval
        let options = UIView.AnimationOptions.beginFromCurrentState
        UIView.animate(withDuration: animationDuration, delay: 0, options:options, animations: { () -> Void in
            self.internalScrollView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            self.internalScrollView?.scrollIndicatorInsets  = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }) { (complete) -> Void in
        }
    }
}


// MARK: - Show/Hide HUD on progress

protocol UILoadingView {
    func showLoading()
    func showLoadingWithLabel(title:String?, subtitle:String)
    func showErrorWithLabel(message: String)
    func showSuccessWithLabel(message:String)
    func hideLoading()
}

extension UILoadingView where Self: UIViewController {
    
    func hideLoading(){
//        HUD.hide()
    }
    func showLoading(){
//        HUD.show(.progress)
    }
    func showLoadingWithLabel(title:String? = "Waiting", subtitle:String){
//        HUD.show(.labeledProgress(title: title, subtitle: subtitle))
    }
    func showErrorWithLabel(message: String){
//        HUD.flash(.labeledError(title: "Failure", subtitle: message), delay: 1.5)
    }
    func showSuccessWithLabel(message:String){
//        HUD.flash(.labeledError(title: "Success", subtitle: message), delay: 1.5)
    }
}
//MARK :- Removed Function
extension UIViewController{
//    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
//        if touch.view is JOIRater {
//            return false
//        }
//        return true
//    }
}
