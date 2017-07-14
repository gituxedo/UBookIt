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
    var marker = GMSMarker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Create a GMSCameraPosition that tells the map to display -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude: 37.3814183, longitude: -121.9582519, zoom: 11.0)
        mapView = GMSMapView.map(withFrame: CGRect(x: 80, y: 67, width: 300, height: 400), camera: camera)
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyKilometer
            locationManager.distanceFilter = 500
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
        
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
        mapView.camera = GMSCameraPosition.camera(withTarget: newLocation!.coordinate, zoom: 13.0)
        mapView.settings.myLocationButton = true
        self.view = self.mapView
        marker.position = CLLocationCoordinate2DMake(newLocation!.coordinate.latitude, newLocation!.coordinate.longitude)
        updateMarker(currentLocation: newLocation!)
    }
    
    func updateMarker(currentLocation: CLLocation) {
        marker.map = nil
        marker = GMSMarker(position: currentLocation.coordinate)
        marker.icon = GMSMarker.markerImage(with: .cyan)
        marker.map = self.mapView
    }
}

//Eric's table: 37.3814183, -121.9582519
