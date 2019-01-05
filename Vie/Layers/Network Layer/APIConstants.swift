//
//  APIConstants.swift
//  Vie
//
//  Created by Meseery on 4/26/17.
//  Copyright © 2017 Enhance. All rights reserved.
//

enum APIConstants:String {
    // API
    case venues = "venues"
    
    static func toDictionary(_ keys:[APIConstants]) -> [String:String] {
        var dict = [String:String]()
        for key in keys {
            dict.updateValue(key.rawValue, forKey: String(describing: key))
        }
        return dict
    }
}
