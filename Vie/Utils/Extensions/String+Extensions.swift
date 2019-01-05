//
//  String+Extensions.swift
//  Joi
//
//  Created by Meseery on 9/17/17.
//  Copyright © 2017 Enhance. All rights reserved.
//

import Foundation
import  UIKit

protocol StringRepresentable {
    var toString : String {get}
}
extension  StringRepresentable {
    var toString : String {
        return String(describing: self).camelCaseToWords()
    }
}

extension String {
    static func localizedString(_ key: String) -> String {
        return Foundation.NSLocalizedString(key, comment: "")
    }
}
extension String {
    var localized: String {
        guard let path = Bundle.main.path(forResource:    Locale.current.regionCode?.lowercased(), ofType: "lproj"), let bundle = Bundle(path: path) else {
            return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        }
        
        return NSLocalizedString(self, tableName: nil, bundle: bundle, value: "", comment: "")
    }
    //Extract String From HTML
    var html2AttributedString: NSAttributedString? {
        return Data(utf8).html2AttributedString
    }
    var html2String: String {
        return html2AttributedString?.string ?? ""
    }
}

extension String {
    
    func camelCaseToWords() -> String {
        
        return unicodeScalars.reduce("") {
            
            if CharacterSet.uppercaseLetters.contains($1) == true {
                
                return ($0 + " " + String($1))
            }
            else {
                
                return $0 + String($1)
            }
        }
    }
    
   
    func capitalizingFirstLetter() -> String {
        return prefix(1).uppercased() + dropFirst()
    }
    
    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    var fullRange:Range<String.Index> { return startIndex..<endIndex }
    func stringByAddingPercentEncodingForRFC3986() -> String? {
        let unreserved = "-._~/?"
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: unreserved)
        return addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
}


extension String {
    func safelyLimitedTo(length n: Int)->String {
        if (self.count <= n) { return self }
        return String(self.prefix(n))
    }
}
extension String {
    /**
     Truncates the string to the specified length number of characters and appends an optional trailing string if longer.
     
     - Parameter length: A `String`.
     - Parameter trailing: A `String` that will be appended after the truncation.
     
     - Returns: A `String` object.
     */
    func truncated(toLength: Int, trailing: String = "…") -> String {
        if self.count > toLength {
            return String(self.prefix(toLength)) + trailing
        } else {
            return self
        }
    }
}
extension String {
    var safeDate:Date?{
        let trimmedString = self.truncated(toLength: 19, trailing: "")
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale.current
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let d = formatter.date(from: trimmedString)
        return d
    }

    var toDate:Date {
        let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            return formatter.date(from: self)!
    }
    
    var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
}

// MARK: - Validations
extension String {
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0 {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesFontLeading, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        return ceil(boundingBox.width)
    }
    func height(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
}

extension NSMutableAttributedString {
    
    func setColorForText(textForAttribute: String, withColor color: UIColor) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }

    func setFontForText(textForAttribute: String, withFont font: UIFont) {
        let range: NSRange = self.mutableString.range(of: textForAttribute, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
    
}

extension StringProtocol {
    var firstUppercased: String {
        guard let first = first else { return "" }
        return String(first).uppercased() + dropFirst()
    }
    var firstCapitalized: String {
        guard let first = first else { return "" }
        return String(first).capitalized + dropFirst()
    }
}


