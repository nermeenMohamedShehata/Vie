//
//  Strings+Additions.swift
//  MyJoi
//
//  Created by Nermeen Mohamed on 11/27/18.
//  Copyright © 2018 Nermeen Mohamed. All rights reserved.
//

import Foundation
// swiftlint:enable explicit_type_interface identifier_name line_length nesting type_body_length type_name
enum L10n {
    /// نعم
    static let english = L10n.tr("Localizable", "English")
    static let arabic = L10n.tr("Localizable", "Arabic")
    static let women = L10n.tr("Localizable", "Women")
    static let men = L10n.tr("Localizable", "Men")
    /// خطآ
    static let error = L10n.tr("Localizable", "Error")
    /// حدث خطأ فى الإتصال
    static let errorInConnection = L10n.tr("Localizable", "error_in_connection")
    /// عذراً
    static let sorryTitle = L10n.tr("Localizable", "sorry_title")

}
extension L10n {
    fileprivate static func tr(_ table: String, _ key: String, _ args: CVarArg...) -> String {
        let format = NSLocalizedString(key, tableName: table, bundle: Bundle(for: BundleToken.self), comment: "")
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

private final class BundleToken {}
