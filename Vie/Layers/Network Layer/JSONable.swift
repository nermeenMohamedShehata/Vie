//
//  JSONable.swift
//  Vie
//
//  Created by Meseery on 9/12/17.
//  Copyright © 2017 Enhance. All rights reserved.
//

import Foundation
import SwiftyJSON

protocol JSONable {
    init?(obj: JSON)
    func to<T>(type: T?) -> Any?
}

extension JSON {
    func to<T>(type: T?) -> Any? {
        if let baseObj = type as? JSONable.Type {
            if self.type == .array {
                var arrObject: [Any] = []
                for obj in self.arrayValue {
                    let object = baseObj.init(obj: obj)
                    arrObject.append(object!)
                }
                return arrObject
            } else {
                let object = baseObj.init(obj: self)
                return object!
            }
        }
        return nil
    }
}
