//
//  VieDataManager.swift
//  Vie
//
//  Created by Meseery on 9/25/17.
//  Copyright © 2017 Enhance. All rights reserved.
//

import UIKit
import Siesta
import Cache
import SwiftyJSON
let sharedDataManager = _VieDataManager()
let appAPIService = _AppAPIService(baseURL: sharedAppConfiguration.environment.baseURL)
typealias onSuccessGet =  ([Any]) -> ()
typealias onSuccessSingleObjectGet =  (Any) -> ()
typealias onUnsafeSuccess = ([Any?]?) -> ()
typealias onSuccessPost = (Any) -> ()
typealias onUnsafePost = (Any?) -> ()
typealias onFailure = (AppError) -> ()
class _VieDataManager: NSObject {
    
    // MARK: - Initial Setup
        override init() {
        super.init()
    }
    

    
    
  //  https://api.foursquare.com/v2/venues/search?ll=40.7,-74&client_id=K2XUW4XTJV2CDZNXCEJPSIQ0UMRQQHG45Q1UU0V4HKEYKTEK&client_secret=2UJKP40R3ARZMFCOCH40DYZIJ13SE0I1ZU5YTSKI55WKABWN&v=20180214
    
    //Get Trending Venues
    @discardableResult func searchVenues(LatLan : String,
        onSuccess:@escaping ([Venue]?)->Void,
        onFailure:@escaping onFailure) -> Resource{
        var resource = appAPIService.venues.child("search")
        resource =  resource.withParam("ll", LatLan)
        print(resource.url)
            resource.GET(onSuccess: { (result) in
            let venues = try? (result as! JSON)["response"]["venues"].arrayValue.map(Venue.init)
            onSuccess(venues)
        }) { (error) in
            onFailure(error)
        }
        return resource
    }

   
    
}
// for uploading image
extension _VieDataManager {
    public enum ImageType {
        case png
        case jpeg
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(UUID().uuidString)"
    }
    
    func constructHttpBodyForImageUpload(withBoundary boundary: String, imageData: Data, fileName: String, imageType: ImageType) -> Data {
        
        let body = NSMutableData()
        
        var mimetype = "image/png" // default
        if imageType == .jpeg {
            mimetype = "image/jpeg"
        }
        
        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(imageData)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
        
        return body as Data
    }

    @discardableResult func uploadImage(_ imageData: Data, fileName: String, imageType: ImageType, productId: String, onSuccess: @escaping () -> Void, onFailure: @escaping (String) -> Void) -> Request {
        let service = Service(baseURL: "\(appAPIService.baseURL!)", standardTransformers: [.text,.image])

        let boundary = generateBoundaryString()
        let request = service.resource("/media/upload_product_attribute_file/\(productId)").request(.post) {
            // See comments in Siesta Resource.swift class for .post
            $0.httpBody = self.constructHttpBodyForImageUpload(withBoundary: boundary, imageData: imageData, fileName: fileName, imageType: imageType)
            $0.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            if let authToken = UserDefaults.currentAuthToken {
                $0.allHTTPHeaderFields = ["Authorization":authToken]
               // $0.addValue("Authorization", forHTTPHeaderField: authToken)
            }
        }

        // My Server returns me JSON back
        request.onSuccess { entity in
            guard let json: [String: String] = entity.typedContent() else {
                onFailure("JSON parsing error")
                return
            }
            guard let status = json["status"] else {
                onFailure("Responce status is missing")
                return
            }
            print("status = \(status)")
            }.onFailure { (error) in
                onFailure(error.userMessage)
        }
        
        return request
    }
}
