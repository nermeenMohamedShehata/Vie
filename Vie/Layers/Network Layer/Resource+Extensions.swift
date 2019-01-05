//
//  Resource+Extensions.swift
//  Vie
//
//  Created by Meseery on 9/25/17.
//  Copyright © 2017 Enhance. All rights reserved.
//

import Foundation
import Siesta
import SwiftyJSON

extension Resource {
    
    // MARK: - GET
    func GET(withParams params:[String:String]? = nil,
              onSuccess:@escaping (Any)->(),
              onFailure:@escaping (AppError)->())  {
        
        var request = self.request(.get)
        if let parameters = params {
            request = self.request(.get, json: parameters)            
        }
        self.load(using: request).onSuccess { (data) in onSuccess(data.content)}.onFailure { (error) in onFailure(AppError(error: error))}
    }
    
    // MARK: - POST
    func POST(withData data:Data,
              contentType content:String,
              onSuccess:@escaping (Any)->(),
              onFailure:@escaping (AppError)->())  {
        let request = self.request(.post, data: data, contentType: content)
        self.load(using: request).onSuccess { (data) in
            onSuccess(data.content)
            }.onFailure { (error) in onFailure(AppError(error: error))}
    }

    
    func POST(withParams params:[String:String],
              onSuccess:@escaping (Any)->(),
              onFailure:@escaping (AppError)->())  {
        let request = self.request(.post, json: params)
        self.load(using: request).onSuccess { (data) in
                onSuccess(data.content)
            }.onFailure { (error) in onFailure(AppError(error: error))}
    }
    
    func POST(withJson json:String?,
              onSuccess:@escaping (Any)->(),
              onFailure:@escaping (AppError)->())  {
        var request = self.request(.post)
        if let jsonString = json {
            request = self.request(.post, text: jsonString)
        }
        self.service.invalidateConfiguration()
        self.load(using: request)
            .onSuccess { (data) in
            onSuccess(data.content)
            }.onFailure { (error) in onFailure(AppError(error: error))}
    }
    
    func POST(withJson json:Dictionary<String, Any>?,
              onSuccess:@escaping (Any)->(),
              onFailure:@escaping (AppError)->())  {
        var request = self.request(.post)
        if let params = json {
            request = self.request(.post, json: params)
        }
        self.load(using: request).onSuccess { (data) in
                onSuccess(data.content)
            }.onFailure { (error) in onFailure(AppError(error: error))}
    }
    
 
  
}
