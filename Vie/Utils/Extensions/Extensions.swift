//
//  Extensions.swift
//
//  Created by Meseery on 8/22/17.
//  Copyright © 2017 Enhance. All rights reserved.
//

import UIKit
import Foundation

func using<T: AnyObject>(object: T, execute: (T) throws -> Void) rethrows -> T {
    try execute(object)
    return object
}

extension NumberFormatter {
    public static func formatter(forCurrencyCode currencyCode: String) -> NumberFormatter {
       let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.usesGroupingSeparator = true
        formatter.locale = NSLocale.current
        formatter.locale = Locale(identifier: "en_US")
        formatter.currencyCode = currencyCode
        formatter.negativePrefix = "\(formatter.negativePrefix!) "
        formatter.positivePrefix = "\(formatter.positivePrefix!) "
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        return formatter
    }
}

extension String {
    public static func price(_ price: Double, currencyCode: String) -> String? {
        var number  = NSNumber(value: price)
        if price.truncatingRemainder(dividingBy: 1.0) == 0 {
            number = NSNumber(integerLiteral: Int(price))
        }

        return NumberFormatter.formatter(forCurrencyCode: currencyCode).string(from: number)
    }
    
    public func price(_ price: Double) -> String? {
        return String.price(price, currencyCode: self)
    }
}

extension Double {
    public func formattedAs(currencyWithCode currencyCode: String) -> String? {
        return currencyCode.price(self)
    }
}

extension UIPageControl {
    func magnifyCurrentPage()  {
        for dot in self.subviews {
            dot.transform = CGAffineTransform.identity
        }
        let current = self.subviews[self.currentPage]
        current.transform = CGAffineTransform.init(scaleX: 1.2, y: 1.2)
    }
}

private var __maxLengths = [UITextField: Int]()
extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
                return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        let t = textField.text
        textField.text = t?.safelyLimitedTo(length: maxLength)
    }
    
    func showDoneButtonOnKeyboard() {
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(resignFirstResponder))
        
        var toolBarItems = [UIBarButtonItem]()
        toolBarItems.append(flexSpace)
        toolBarItems.append(doneButton)
        
        let doneToolbar = UIToolbar()
        doneToolbar.items = toolBarItems
        doneToolbar.sizeToFit()
        
        inputAccessoryView = doneToolbar
    }
}

extension UIViewController{
    func addCloseButtonToKeyboard(_ textView : UITextView){
        //Declared at top of view controller
        var accessoryDoneButton: UIBarButtonItem!
        let accessoryToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 44))
        //Could also be an IBOutlet, I just happened to have it like this
        
        //Configured in viewDidLoad()
        
        accessoryDoneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.donePressed))
        accessoryToolBar.items = [accessoryDoneButton]
        textView.inputAccessoryView = accessoryToolBar
    }

    
    @objc func donePressed() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}

