//
//  UserSettings.swift
//  MyJoi
//
//  Created by Nerneen Mohamed on 11/26/18.
//  Copyright © 2018 Nermeen Mohamed. All rights reserved.
//

import Foundation
/*---UserDefaults---*/
extension UserDefaults{
    enum UserDefaultsKeys: String {
        case authTokenKey = "basicAuthHeader"
    }
    
    static var currentAuthToken : String? {
        get {
            print(UserDefaultsKeys.authTokenKey.rawValue)
            return UserDefaults.standard.string(forKey:UserDefaultsKeys.authTokenKey.rawValue)
        }
        set{
            UserDefaults.standard.set(newValue, forKey: UserDefaultsKeys.authTokenKey.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
}
