//
//  AppConfigurations.swift
//  Joi
//
//  Created by Meseery on 9/26/17.
//  Copyright © 2017 Enhance. All rights reserved.
//

import Foundation

var sharedAppConfiguration = AppConfiguration()

struct AppConfiguration {
    lazy var environment: AppEnvironment = {
        if let configuration =  Bundle.main.object(forInfoDictionaryKey: "Configuration") as? String {
            if configuration.range(of:"Staging") != nil {
                return AppEnvironment.Staging
            }
        }
        return AppEnvironment.Production
    }()
}

enum AppEnvironment: String {
    case Staging = "staging"
    case Production = "production"
    case Testing = "testing"
    
    var baseURL: String {
        switch self {
        case .Production:   return "https://api.foursquare.com/v2"
        case .Staging:      return "https://api.foursquare.com/v2"
        case .Testing:      return "https://api.foursquare.com/v2"
        }
    }
    var mode: String {
        return "json"
    }
    
}






