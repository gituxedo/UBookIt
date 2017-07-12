//
//  LocationViewController.swift
//  UBookIt
//
//  Created by apple on 7/11/17.
//  Copyright © 2017 Sylvia Jin. All rights reserved.
//

import Foundation
import UIKit
import FirebaseAuth
import FirebaseDatabase
import GoogleMaps

class LocationViewController: UIViewController, CLLocationManagerDelegate, GMSMapViewDelegate {
    
    @IBOutlet var mapView: GMSMapView!
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a GMSCameraPosition that tells the map to display -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 37.3814183, longitude: -121.9582519, zoom: 11.0)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        self.view = mapView
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.distanceFilter = 500
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        // Creates a marker in the center of the map.
//        let marker = GMSMarker()
//        marker.position = CLLocationCoordinate2D(latitude: 37.3814183, longitude: -121.9582519)
//        marker.title = "Hacker Dojo"
//        marker.snippet = "Santa Clara, CA"
//        marker.map = mapView
        
        let position = CLLocationCoordinate2D(latitude: 37.5515778, longitude: -121.9536696)
        let marker2 = GMSMarker(position: position)
        marker2.title = "Caterpillar"
        marker2.snippet = "Fremont, CA"
        marker2.icon = GMSMarker.markerImage(with: .green)
        marker2.map = mapView
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            locationManager.startUpdatingLocation()
            // if permission granted- starting updating location
            mapView.isMyLocationEnabled = true
            mapView.settings.myLocationButton = true
        }
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let newLocation = locations.last
        mapView.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: 15.0)
        mapView.settings.myLocationButton = true
        self.view = self.mapView
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(newLocation!.coordinate.latitude, newLocation!.coordinate.longitude)
        marker.icon = GMSMarker.markerImage(with: .black)
        marker.map = self.mapView
    }
}

//Eric's table: 37.3814183, -121.9582519
