//
//  JOAPILayer.swift
//  Vie
//
//  Created by Meseery on 4/18/17.
//  Copyright © 2017 Enhance. All rights reserved.
//

import Siesta
import SwiftyJSON

class RequestAPI {
    private let resource: Resource

   init(_ resource: Resource)  {
        self.resource = resource
    }
    
    func adapt(_ urlRequest: Resource) throws -> Resource {
//        var urlRequest = urlRequest.withParam("languageId", UserDefaults.currentLanguage?.id).withParam("storeId", UserDefaults.currentStore?.Id)
        return urlRequest
    }
}

class _AppAPIService: Service {
    
    private let SwiftyJSONTransformer =
        ResponseContentTransformer
            {JSON($0.content as AnyObject)}
    
    init(baseURL:String) {
        super.init(baseURL: baseURL)
        setuoConfigurations()
    }
    
    
    // MARK: - Configurations
    func setuoConfigurations()  {
        
        // Global configuration
        #if DEBUG
            LogCategory.enabled = [.network]
            LogCategory.enabled = LogCategory.common
            LogCategory.enabled = LogCategory.detailed
        #endif
        
        configure{
            $0.pipeline[.parsing].add(self.SwiftyJSONTransformer, contentTypes: ["*/json"])
            $0.pipeline[.cleanup].add(JOIErrorMessageExtractor())
            
            $0.headers["Accept"] = "application/json"
        
            $0.mutateRequests { req in
                guard
                    let url = req.url,
                    var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {return}
                components.queryItems =
                    (components.queryItems ?? [])
                    + [URLQueryItem(name: "client_id", value: AppConstants.fourSquareClientID),URLQueryItem(name: "client_secret", value: AppConstants.fourSquareClientSecret),URLQueryItem(name: "v", value: AppConstants.fourSquareVersion)]
                
//                
//                resource =  resource.withParam("ll", LatLan)
//                resource = resource.withParam("client_id", AppConstants.fourSquareClientID)
//                resource = resource.withParam("client_secret", AppConstants.fourSquareClientSecret)
//                resource = resource.withParam("v", AppConstants.fourSquareVersion)
//
                
                req.url = components.url
            }
        }
        
       
       
/*
        self.configureTransformer("\(JOIAPIConstants.shoppingCartItems.rawValue)/remove_invalid"){
            try? ($0.content as JSON)["customers"].arrayValue.last?.dictionaryValue["shopping_cart_items"]?.flatMap({JOICartItem.init})
        }
 */
    }

    //MARK: - TrendingVenues
    var venues : Resource{
        return resource(APIConstants.venues.rawValue)
    }
    
    
    
    
 
    
    
    func purgeAuthToken() {
        basicAuthHeader = nil
        UserDefaults.currentAuthToken = nil
    }
    
    var isAuthorized: Bool {
        guard UserDefaults.currentAuthToken != nil else {
            return false
        }
        return !(UserDefaults.currentAuthToken?.isEmpty)!
    }
    
    private var basicAuthHeader: String? {
        didSet {
            // These two calls are almost always necessary when you have changing auth for your API:
            self.invalidateConfiguration()  // So that future requests for existing resources pick up config change
            self.wipeResources()            // Scrub all unauthenticated data
            // Note that wipeResources() broadcasts a “no data” event to all observers of all resources.
            // Therefore, if your UI diligently observes all the resources it displays, this call prevents sensitive
            // data from lingering in the UI after logout.
            
        }
    }
    
    /// If the response is JSON and has a "message" value, use it as the user-visible error message.
    private struct JOIErrorMessageExtractor: ResponseTransformer {
        func process(_ response: Response) -> Response {
            switch response {
            case .success:
                return response
                
            case .failure(var error):
                // Note: the .json property here is defined in Siesta+SwiftyJSON.swift
                error.userMessage = error.json["message"].string ?? error.userMessage
                return .failure(error)
            }
        }
    }
}
