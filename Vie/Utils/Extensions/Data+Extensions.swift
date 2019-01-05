//
//  Data+Extensions.swift
//  Vie
//
//  Created by Nerneen Mohamed on 12/6/18.
//  Copyright © 2018 Nermeen Mohamed. All rights reserved.
//

import Foundation
    extension Data {
        var html2AttributedString: NSAttributedString? {
            do {
                return try NSAttributedString(data: self, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding: String.Encoding.utf8.rawValue], documentAttributes: nil)
            } catch {
                print("error:", error)
                return  nil
            }
        }
        var html2String: String {
            return html2AttributedString?.string ?? ""
        }
    }

