//
//  VenueAnnotation.swift
//  Vie
//
//  Created by Nermeen Mohamed on 1/3/19.
//  Copyright © 2019 Nermeen Mohamed. All rights reserved.
//

import Foundation
import Foundation
import MapKit
class VenueAnnotation: NSObject,MKAnnotation{
    var venue : Venue
    dynamic var coordinate: CLLocationCoordinate2D
    
    
    init(venue:Venue) {
        self.venue = venue
        self.coordinate = CLLocationCoordinate2D(latitude: venue.location?.lat ?? 0.0, longitude: venue.location?.lng ?? 0.0)
        super.init()
    }
//    func update(annotationPosition:DriverAnnotation, withCoordinate coordinate :CLLocationCoordinate2D){
//        var location = self.coordinate
//        location.latitude = coordinate.latitude
//        location.longitude = coordinate.longitude
//        UIView.animate(withDuration: 0.2) {
//            self.coordinate = location
//        }
//    }
}
