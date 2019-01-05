//
//  Dictionary+Extensions.swift
//  Joi
//
//  Created by Meseery on 9/18/17.
//  Copyright © 2017 Enhance. All rights reserved.
//

import Foundation

protocol DictionaryRepresentable {
    var toDictionary: [String: AnyObject] { get }
    
    //     init?(dictionary: [String: AnyObject])
}

extension DictionaryRepresentable {
    var toDictionary: [String: AnyObject] {
        var dict: [String: AnyObject] = [:]
        
        for case let (label?, value) in Mirror(reflecting: self).children {
            switch value {
            case let value as DictionaryRepresentable:
                dict[label] = value.toDictionary as AnyObject
            case let value as NSObject:
                dict[label] = value
            default:
                break
            }
        }
        
        return dict
    }
}


func fromDictionaryValue<A>(_ d: [String: AnyObject], name: String) -> A? {
    return d[name] as? A
}
