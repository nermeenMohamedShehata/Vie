//
//  MapVC.swift
//  Vie
//
//  Created by Nermeen Mohamed on 1/3/19.
//  Copyright © 2019 Nermeen Mohamed. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {
    //MARK: - IBOutlets
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mapView: MKMapView!
    
    //MARK: - Variables
    let locationLatLan = "40.7,-74"
    var currentIndex = 0
    var isDragCollectionview = false
    var lastContentOffset = CGFloat()
    var scrollDir = UISwipeGestureRecognizer.Direction.left
    var locationManager : CLLocationManager?
    var regionRadius : CLLocationDistance = 1000
    let sectionInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
    var venues : [Venue]? {
        didSet{
            DispatchQueue.main.async {
                for i in 0..<(self.venues?.count)!{
                    self.venues![i].index = i
                }
                //Remove Exist Annotations
                self.removerAllAnnotationFromMap()
                self.addVenueAnnotationsToMap()
                self.collectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupViews()
        getVenues()
    }
    //MAR:: - Setup
    func setupViews(){
        setupLocationManager()
        setupNavigationBar()
    //    setupCollectionView()
    }
    
    func setupNavigationBar()  {
        let listButton = UIButton.listButton
        listButton.addTarget(self, action: #selector(didTapList(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: listButton)
    }

    func setupLocationManager(){
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestWhenInUseAuthorization()
        self.locationManager?.startUpdatingLocation()
        self.mapView.showsUserLocation = true
    }
    func checkLocationAuthStatus(){
        if CLLocationManager.authorizationStatus() == .authorizedAlways{
            locationManager?.startUpdatingLocation()
            mapView.showsUserLocation = true
        }else{
            locationManager?.requestAlwaysAuthorization()
        }
    }
    func getVenues(){
        sharedDataManager.searchVenues(LatLan: locationLatLan, onSuccess: { (venues) in
            print(venues?.count)
            self.venues = venues ?? []
        }) { (error) in
            print(error)
        }
    }
    @objc func didTapList(_ sender:UIBarButtonItem )  {
        let venueListScene = StoryboardScene.Main.venueListVC.instantiate()
        venueListScene.venues  = venues
        self.navigationController?.pushViewController(venueListScene, animated: false)
    }
   
}
//MARK: - Annotation Functions
extension MapVC {
    func addVenueAnnotationsToMap(){
        guard venues != nil else { return }
        for venue in venues!{
            let venueAnnotation = VenueAnnotation(venue: venue)
            mapView.addAnnotation(venueAnnotation)
        }
        self.zoom(toFitAnnotationsFromMapView: self.mapView)
    }
    func removerAllAnnotationFromMap(){
        self.mapView.removeAnnotations(self.mapView.annotations)
    }
    func centerMapOnSelectedAnnotation(_ locationCoordinate: CLLocationCoordinate2D){
        let coordinateRegion = MKCoordinateRegion(center:locationCoordinate, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    func zoom(toFitAnnotationsFromMapView mapView : MKMapView){
        if mapView.annotations.count == 0{
            return
        }
        var topLeftCoordinate = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoordinate = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        for annotation in self.mapView.annotations{
            if let annotation = annotation as? VenueAnnotation{
                topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, annotation.coordinate.longitude)
                topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, annotation.coordinate.latitude)
                bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, annotation.coordinate.longitude)
                bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, annotation.coordinate.latitude)
            }
        }
        
        for annotation in mapView.annotations where !annotation.isKind(of: VenueAnnotation.self){
            topLeftCoordinate.longitude = fmin(topLeftCoordinate.longitude, annotation.coordinate.longitude)
            topLeftCoordinate.latitude = fmax(topLeftCoordinate.latitude, annotation.coordinate.latitude)
            bottomRightCoordinate.longitude = fmax(bottomRightCoordinate.longitude, annotation.coordinate.longitude)
            bottomRightCoordinate.latitude = fmin(bottomRightCoordinate.latitude, annotation.coordinate.latitude)
        }
        var region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(topLeftCoordinate.latitude - (topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 0.5, topLeftCoordinate.longitude + (bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 0.5), span: MKCoordinateSpan(latitudeDelta: fabs(topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 2.0, longitudeDelta: fabs(bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 2.0))
        
        region = mapView.regionThatFits(region)
        mapView.setRegion(region, animated: true)
    }
    
}
