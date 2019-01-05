//
//  VieDataManager+DynamicLinks.swift
//  Vie
//
//  Created by Nermeen Mohamed on 1/5/19.
//  Copyright © 2019 Nermeen Mohamed. All rights reserved.
//

import Foundation
extension _VieDataManager{
   
    func createShareVenueURL(for venueId: String) -> URL{
        //        https://api.foursquare.com/v2/venues/412d2800f964a520df0c1fe3?client_id=DQOPR4USW24ZFL1GTKLU55DXLYNGP4COL5E0WK2NI4T4ONFC&client_secret=AVNKISND3U5ULOLMLEUIPVWGUZ4FJ24E4Y2RMKIQTYI35DL4&v=20180214
        var resource = appAPIService.venues.child("\(venueId)")
        resource = resource.withParam("client_id", AppConstants.fourSquareClientID)
        resource = resource.withParam("client_secret", AppConstants.fourSquareClientSecret)
        resource = resource.withParam("v", AppConstants.fourSquareVersion)
        return resource.url
    }
}
