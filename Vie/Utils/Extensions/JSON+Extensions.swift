//
//  JSON+Extensions.swift
//  Joi
//
//  Created by Meseery on 9/18/17.
//  Copyright © 2017 Enhance. All rights reserved.
//

import Foundation

protocol JSONRepresentable {
    var JSONRepresentation: Dictionary<String,Any> { get }
}

extension JSONRepresentable {
    var JSONRepresentation: Dictionary<String,Any> {
        var representation = [String: Any]()
        
        for case let (label?, value) in Mirror(reflecting: self).children {
            
            switch value {
                
            case let value as Dictionary<String, Any>:
                representation[label] = value as AnyObject
                
            case let value as Array<Any>:
                if let val = value as? [JSONRepresentable] {
                    representation[label] = val.map({ $0.JSONRepresentation as AnyObject }) as AnyObject
                } else {
                    representation[label] = value as AnyObject
                }
                
            case let value:
                representation[label] = value as AnyObject
                
            }
        }
        return representation 
    }
}

extension JSONRepresentable {
    func toJSON() -> String? {
        let representation = JSONRepresentation
        
        guard JSONSerialization.isValidJSONObject(representation) else {
            print("Invalid JSON Representation")
            return nil
        }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: representation, options: [])
            
            return String(data: data, encoding: .utf8)
        } catch {
            return nil
        }
    }
}
 
