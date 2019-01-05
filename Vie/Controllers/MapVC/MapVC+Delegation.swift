//
//  MapVC+Delegation.swift
//  Vie
//
//  Created by Nermeen Mohamed on 1/4/19.
//  Copyright © 2019 Nermeen Mohamed. All rights reserved.
//

import Foundation
import MapKit
import CoreLocation
//MARK: - CLLocationManagerDelegate
extension MapVC : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthStatus()
        if status == .authorizedWhenInUse || status == .authorizedAlways{
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {}
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {}
    
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors " + error.localizedDescription)
    }
    
}
//MARK: - MKMapViewDelegate & Annotation Delegate Functions
extension MapVC : MKMapViewDelegate{
   
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let _ = annotation as? VenueAnnotation{
            let identifier = "venue"
            var view : MKAnnotationView
            view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.image = UIImage(named: "venue")
            return view
        }
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let annotation = view.annotation as? VenueAnnotation{
            centerMapOnSelectedAnnotation(annotation.coordinate)
            view.image = UIImage(named: "selectedVenue")
            if !isDragCollectionview{
                self.collectionView.scrollToItem(at: IndexPath(row: annotation.venue.index!, section: 0), at: .centeredHorizontally, animated: true)
           }
            isDragCollectionview = false
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        view.image = UIImage(named: "venue")
    }
    
}
